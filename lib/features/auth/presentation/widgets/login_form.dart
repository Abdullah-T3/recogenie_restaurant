import 'package:flutter/material.dart';
import 'package:recogenie_restaurant/core/Responsive/models/DeviceInfo.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../../core/widgets/card_container.dart';
import '../../../../core/helper/FormValidator/Validator.dart';

class LoginForm extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isLoading;
  final VoidCallback onLogin;
  final VoidCallback? onForgotPassword;
  final VoidCallback? onSignUp;
  final Deviceinfo deviceInfo;
  const LoginForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.isLoading,
    required this.onLogin,
    this.onForgotPassword,
    this.onSignUp,
    required this.deviceInfo,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  @override
  Widget build(BuildContext context) {
    return CardContainer(
      padding: EdgeInsets.all(widget.deviceInfo.screenWidth * 0.05),
      borderRadius: widget.deviceInfo.screenWidth * 0.05,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: widget.deviceInfo.screenWidth * 0.02,
          offset: const Offset(0, 8),
        ),
      ],
      child: Column(
        children: [
          // Email Field
          CustomTextField(
            controller: widget.emailController,
            labelText: 'Email Address',
            hintText: 'Enter your email address',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: ValidatorHelper.combineValidators([
              ValidatorHelper.isNotEmpty,
              ValidatorHelper.isValidEmail,
            ]),
          ),

          SizedBox(height: widget.deviceInfo.screenHeight * 0.02),

          // Password Field
          CustomTextField(
            controller: widget.passwordController,
            labelText: 'Password',
            hintText: 'Enter your password',
            prefixIcon: Icons.lock_outlined,
            obscureText: true,
            validator: ValidatorHelper.combineValidators([
              ValidatorHelper.isNotEmpty,
              ValidatorHelper.isValidPassword,
            ]),
          ),

          SizedBox(height: widget.deviceInfo.screenHeight * 0.02),
          GradientButton(
            text: 'Sign In',
            icon: Icons.login,
            isLoading: widget.isLoading,
            onPressed: widget.onLogin,
            deviceinfo: widget.deviceInfo,
          ),
        ],
      ),
    );
  }
}
