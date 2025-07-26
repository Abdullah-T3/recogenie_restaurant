import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recogenie_restaurant/core/Responsive/UiComponents/InfoWidget.dart';
import 'package:recogenie_restaurant/core/Responsive/models/DeviceInfo.dart';
import 'package:recogenie_restaurant/core/helper/cherryToast/CherryToastMsgs.dart';
import 'package:recogenie_restaurant/features/auth/presentation/widgets/sign_up_link.dart';
import '../../../../core/theme/app_theme.dart';
import '../cubit/auth_cubit.dart';
import '../widgets/animated_logo.dart';
import '../widgets/gradient_text.dart';
import '../widgets/login_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    return Scaffold(
      backgroundColor: AppTheme.surfaceColor,
      body: InfoWidget(
        builder: (context, deviceInfo) => Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.primaryColor.withOpacity(0.1),
                AppTheme.backgroundColor,
                AppTheme.surfaceColor,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
          child: SafeArea(
            child: BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is AuthSuccess) {
                  CherryToastMsgs.CherryToastSuccess(
                    info: deviceInfo,
                    context: context,
                    title: 'Login Successful',
                    description:
                        'Welcome back, ${state.user.displayName ?? 'User'}!',
                  ).show(context);
                  // Router will handle navigation automatically
                } else if (state is AuthFailure) {
                  CherryToastMsgs.CherryToastError(
                    info: deviceInfo,
                    context: context,
                    title: 'Error',
                    description: state.message,
                  ).show(context);
                }
              },
              builder: (context, state) {
                final isLoading = state is AuthLoading;
                return SingleChildScrollView(
                  padding: EdgeInsets.all(deviceInfo.localWidth * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: deviceInfo.screenHeight * 0.05),
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: _buildWelcomeSection(deviceInfo),
                      ),
                      SizedBox(height: deviceInfo.screenHeight * 0.05),
                      SlideTransition(
                        position: _slideAnimation,
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: LoginForm(
                            deviceInfo: deviceInfo,
                            emailController: authCubit.emailController,
                            passwordController: authCubit.passwordController,
                            isLoading: isLoading,
                            onLogin: () {
                              authCubit.signInWithEmail();
                            },
                            onForgotPassword: () {},
                          ),
                        ),
                      ),

                      SizedBox(height: deviceInfo.screenHeight * 0.03),
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: _buildForgotPasswordLink(deviceInfo, () {}),
                      ),
                      SizedBox(height: deviceInfo.screenHeight * 0.03),
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: SignUpLink(onSignUp: () {}),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(Deviceinfo deviceInfo) {
    return Column(
      children: [
        AnimatedLogo(
          size: deviceInfo.screenHeight * 0.13,
          icon: Icons.restaurant_menu,
          color: AppTheme.primaryColor,
        ),

        SizedBox(height: deviceInfo.screenHeight * 0.01),

        GradientText(
          text: 'Welcome Back!',
          style: TextStyle(
            fontSize: deviceInfo.screenHeight * 0.036,
            fontWeight: FontWeight.w800,
          ),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: deviceInfo.screenHeight * 0.01),

        Text(
          'Sign in to continue to your account',
          style: AppTheme.bodyText2.copyWith(
            color: AppTheme.textSecondaryColor,
            fontSize: deviceInfo.screenHeight * 0.02,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildForgotPasswordLink(
    Deviceinfo deviceInfo,
    VoidCallback onPressed,
  ) {
    return Center(
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: deviceInfo.screenWidth * 0.05,
            vertical: deviceInfo.screenHeight * 0.01,
          ),
        ),
        child: Text(
          'Forgot Password?',
          style: AppTheme.bodyText2.copyWith(
            color: AppTheme.primaryColor,
            decoration: TextDecoration.underline,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
