import 'package:flutter/material.dart';
import 'card_container.dart';
import '../../../../core/theme/app_theme.dart';

class SignUpLink extends StatelessWidget {
  final VoidCallback? onSignUp;
  final String questionText;
  final String actionText;

  const SignUpLink({
    super.key,
    this.onSignUp,
    this.questionText = "Don't have an account? ",
    this.actionText = 'Sign Up',
  });

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            questionText,
            style: AppTheme.bodyText2.copyWith(
              color: AppTheme.textSecondaryColor,
            ),
          ),
          TextButton(
            onPressed: onSignUp,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              actionText,
              style: AppTheme.bodyText2.copyWith(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w700,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
