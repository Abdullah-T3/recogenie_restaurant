import 'package:flutter/material.dart';
import '../../../../core/widgets/card_container.dart';
import '../../../../core/theme/app_theme.dart';

class LoginLink extends StatelessWidget {
  final VoidCallback? onLogin;
  final String questionText;
  final String actionText;

  const LoginLink({
    super.key,
    this.onLogin,
    this.questionText = "Already have an account? ",
    this.actionText = 'Sign In',
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
            onPressed: onLogin,
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
