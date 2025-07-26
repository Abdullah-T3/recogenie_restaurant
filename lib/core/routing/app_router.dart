import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:recogenie_restaurant/core/di/injection.dart';
import 'package:recogenie_restaurant/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:recogenie_restaurant/features/menu/presentation/cubit/menu_cubit.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/sign_up_screen.dart';
import '../../features/auth/presentation/screens/profile_screen.dart';
import '../../features/menu/presentation/screens/menu_page.dart';
import '../../features/cart/presentation/cart_page.dart';
import 'routs.dart';
import '../../features/auth/data/repo/auth_repository.dart';

class _AuthRefreshNotifier extends ChangeNotifier {
  void refresh() => notifyListeners();
}

class AppRouter {
  static final _authRefreshNotifier = _AuthRefreshNotifier();

  static void refreshAuth() => _authRefreshNotifier.refresh();

  static final GoRouter router = GoRouter(
    initialLocation: Routes.loginScreen,
    refreshListenable: _authRefreshNotifier,
    redirect: (context, state) {
      final authRepository = getIt<AuthRepository>();
      final isAuthenticated = authRepository.currentUser != null;

      if (isAuthenticated &&
          (state.matchedLocation == Routes.loginScreen ||
              state.matchedLocation == Routes.signUpScreen)) {
        return Routes.menuScreen;
      }

      if (!isAuthenticated &&
          state.matchedLocation != Routes.loginScreen &&
          state.matchedLocation != Routes.signUpScreen) {
        return Routes.loginScreen;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: Routes.loginScreen,
        name: 'login',
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<AuthCubit>(),
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: Routes.signUpScreen,
        name: 'signup',
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<AuthCubit>(),
          child: const SignUpScreen(),
        ),
      ),
      GoRoute(
        path: Routes.profileScreen,
        name: 'profile',
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<AuthCubit>(),
          child: const ProfileScreen(),
        ),
      ),
      GoRoute(
        path: Routes.menuScreen,
        name: 'menu',
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<MenuCubit>(),
          child: const MenuPage(),
        ),
      ),
      GoRoute(
        path: Routes.cartScreen,
        name: 'cart',
        builder: (context, state) => const CartPage(),
      ),
      GoRoute(
        path: Routes.homeScreen,
        name: 'home',
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text('Home Screen'))),
      ),
    ],
    errorBuilder: (context, state) =>
        const Scaffold(body: Center(child: Text('Page not found'))),
  );
}
