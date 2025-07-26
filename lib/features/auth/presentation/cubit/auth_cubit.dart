import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import '../../data/repo/auth_repository.dart';
import '../../../../core/routing/app_router.dart';

part 'auth_state.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  AuthCubit(this._authRepository) : super(AuthInitial());

  Future<void> signInWithEmail() async {
    emit(AuthLoading());
    try {
      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
        emit(AuthFailure('Email and password cannot be empty.'));
        return;
      }
      if (passwordController.text.length < 6) {
        emit(AuthFailure('Password must be at least 6 characters long.'));
        return;
      }
      final user = await _authRepository.signInWithEmail(
        emailController.text,
        passwordController.text,
      );
      if (user != null) {
        emit(AuthSuccess(user));
        AppRouter.refreshAuth(); // Refresh router to handle redirect
      } else {
        emit(AuthFailure('Login failed'));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> signUpWithEmail() async {
    emit(AuthLoading());
    try {
      if (emailController.text.isEmpty ||
          passwordController.text.isEmpty ||
          nameController.text.isEmpty) {
        emit(AuthFailure('All fields are required.'));
        return;
      }
      if (passwordController.text.length < 6) {
        emit(AuthFailure('Password must be at least 6 characters long.'));
        return;
      }
      if (passwordController.text != confirmPasswordController.text) {
        emit(AuthFailure('Passwords do not match.'));
        return;
      }
      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(emailController.text)) {
        emit(AuthFailure('Invalid email format.'));
        return;
      }

      final user = await _authRepository.signUpWithEmail(
        emailController.text,
        passwordController.text,
        nameController.text,
      );
      if (user != null) {
        emit(AuthSuccess(user));
        AppRouter.refreshAuth(); // Refresh router to handle redirect
      } else {
        emit(AuthFailure('Sign up failed'));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> signOut() async {
    emit(AuthLoading());
    try {
      await _authRepository.signOut();
      emit(AuthInitial());
      AppRouter.refreshAuth(); // Refresh router to handle redirect
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  void clearControllers() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    nameController.clear();
  }

  Future<void> checkAuthState() async {
    emit(AuthLoading());
    try {
      final user = _authRepository.currentUser;
      if (user != null) {
        emit(AuthSuccess(user));
      } else {
        emit(AuthInitial());
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
