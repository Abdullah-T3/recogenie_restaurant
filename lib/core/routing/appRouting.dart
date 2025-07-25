import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:recogenie_restaurant/core/routing/routs.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: Routes.splashScreen,

    routes: [
      GoRoute(path: Routes.splashScreen),
      GoRoute(path: Routes.loginScreen),
    ],
  );
}
