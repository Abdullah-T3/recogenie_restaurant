import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/Responsive/UiComponents/InfoWidget.dart';
import '../../../../core/Responsive/models/DeviceInfo.dart';
import '../../../../core/helper/cherryToast/CherryToastMsgs.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/di/injection.dart';
import '../cubit/auth_cubit.dart';
import '../../../../core/widgets/gradient_text.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<AuthCubit>()..checkAuthState(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppTheme.backgroundColor, AppTheme.surfaceColor],
            ),
          ),
          child: InfoWidget(
            builder: (context, deviceInfo) => Padding(
              padding: EdgeInsets.all(deviceInfo.screenWidth * 0.05),
              child: BlocListener<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is AuthInitial) {
                    CherryToastMsgs.CherryToastSuccess(
                      context: context,
                      title: 'Logged Out',
                      description: 'You have been successfully logged out.',
                      info: deviceInfo,
                    ).show(context);
                  }
                },
                child: BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    if (state is AuthLoading) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.primaryColor,
                        ),
                      );
                    } else if (state is AuthFailure) {
                      return Center(
                        child: Text(
                          state.message,
                          style: AppTheme.bodyText1.copyWith(
                            color: AppTheme.errorColor,
                          ),
                        ),
                      );
                    } else if (state is AuthSuccess) {
                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildProfileHeader(
                              deviceInfo,
                              state.user.displayName ?? 'User',
                            ),
                            SizedBox(height: deviceInfo.screenHeight * 0.02),
                            _buildUserInfo(deviceInfo, state.user),
                            SizedBox(height: deviceInfo.screenHeight * 0.02),
                            _buildActionButtons(context, deviceInfo),
                          ],
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(Deviceinfo deviceInfo, String name) {
    return Container(
      padding: EdgeInsets.all(deviceInfo.screenWidth * 0.05),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(deviceInfo.screenWidth * 0.05),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowColor,
            blurRadius: deviceInfo.screenWidth * 0.02,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: deviceInfo.screenWidth * 0.1,
            backgroundColor: AppTheme.primaryColor,
            child: Icon(
              Icons.person,
              size: deviceInfo.screenWidth * 0.08,
              color: Colors.white,
            ),
          ),
          SizedBox(height: deviceInfo.screenHeight * 0.02),
          GradientText(
            text: name,
            style: TextStyle(
              fontSize: deviceInfo.screenHeight * 0.03,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfo(Deviceinfo deviceInfo, User user) {
    return Container(
      padding: EdgeInsets.all(deviceInfo.screenWidth * 0.05),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(deviceInfo.screenWidth * 0.05),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowColor,
            blurRadius: deviceInfo.screenWidth * 0.02,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Account Information',
            style: AppTheme.headline4.copyWith(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: deviceInfo.screenHeight * 0.02),
          _buildInfoRow('Name', user.displayName!, deviceInfo),
          SizedBox(height: deviceInfo.screenHeight * 0.01),
          _buildInfoRow('Email', user.email!, deviceInfo),
          SizedBox(height: deviceInfo.screenHeight * 0.01),
          _buildInfoRow('Status', 'Active', deviceInfo),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, Deviceinfo deviceInfo) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: deviceInfo.screenHeight * 0.01),
      child: Row(
        children: [
          Text(
            label,
            style: AppTheme.bodyText1.copyWith(
              color: AppTheme.textSecondaryColor,
              fontWeight: FontWeight.w500,
              fontSize: deviceInfo.screenHeight * 0.018,
            ),
          ),
          SizedBox(width: deviceInfo.screenWidth * 0.02),
          Text(
            value,
            style: AppTheme.bodyText1.copyWith(
              color: AppTheme.textPrimaryColor,
              fontWeight: FontWeight.w600,
              overflow: TextOverflow.ellipsis,
              fontSize: deviceInfo.screenHeight * 0.018,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, Deviceinfo deviceInfo) {
    return Container(
      padding: EdgeInsets.all(deviceInfo.screenWidth * 0.05),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(deviceInfo.screenWidth * 0.05),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowColor,
            blurRadius: deviceInfo.screenWidth * 0.02,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Actions',
            style: AppTheme.headline4.copyWith(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: deviceInfo.screenHeight * 0.02),

          SizedBox(
            width: double.infinity,
            height: deviceInfo.screenHeight * 0.06,
            child: ElevatedButton.icon(
              onPressed: () {
                CherryToastMsgs.CherryToastError(
                  context: context,
                  title: 'Coming Soon',
                  description:
                      'Profile editing feature will be available soon.',
                  info: deviceInfo,
                ).show(context);
              },
              icon: const Icon(Icons.edit),
              label: const Text('Edit Profile'),
              style: AppTheme.primaryButtonStyle,
            ),
          ),

          SizedBox(height: deviceInfo.screenHeight * 0.02),

          SizedBox(
            width: double.infinity,
            height: deviceInfo.screenHeight * 0.06,
            child: ElevatedButton.icon(
              onPressed: () {
                CherryToastMsgs.CherryToastError(
                  context: context,
                  title: 'Coming Soon',
                  description: 'Settings feature will be available soon.',
                  info: deviceInfo,
                ).show(context);
              },
              icon: const Icon(Icons.settings),
              label: const Text('Settings'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.surfaceColor,
                foregroundColor: AppTheme.primaryColor,
                side: BorderSide(color: AppTheme.primaryColor),
              ),
            ),
          ),

          SizedBox(height: deviceInfo.screenHeight * 0.02),
          SizedBox(
            width: double.infinity,
            height: deviceInfo.screenHeight * 0.06,
            child: ElevatedButton.icon(
              onPressed: () => _showLogoutDialog(context),
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.errorColor,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                getIt<AuthCubit>().signOut();
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
