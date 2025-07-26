import 'package:flutter/material.dart';
import 'package:recogenie_restaurant/core/Responsive/models/DeviceInfo.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../../core/widgets/card_container.dart';
import '../../../../core/helper/FormValidator/Validator.dart';

class SignUpForm extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController nameController;
  final bool isLoading;
  final VoidCallback onSignUp;
  final Deviceinfo deviceInfo;

  const SignUpForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.nameController,
    required this.isLoading,
    required this.onSignUp,
    required this.deviceInfo,
  });

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: CardContainer(
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
            // Name Field
            CustomTextField(
              controller: widget.nameController,
              labelText: 'Full Name',
              hintText: 'Enter your full name',
              prefixIcon: Icons.person_outlined,
              keyboardType: TextInputType.name,
              validator: ValidatorHelper.combineValidators([
                ValidatorHelper.isNotEmpty,
              ]),
            ),
            SizedBox(height: widget.deviceInfo.screenHeight * 0.02),

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

            CustomTextField(
              controller: widget.confirmPasswordController,
              labelText: 'Confirm Password',
              hintText: 'Confirm your password',
              prefixIcon: Icons.lock_outlined,
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your password';
                }
                if (value != widget.passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),

            SizedBox(height: widget.deviceInfo.screenHeight * 0.02),

            GradientButton(
              text: 'Sign Up',
              icon: Icons.person_add,
              isLoading: widget.isLoading,
              onPressed: () {
                widget.onSignUp();
              },
              deviceinfo: widget.deviceInfo,
            ),
          ],
        ),
      ),
    );
  }
}
