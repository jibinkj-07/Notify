import 'package:flutter/material.dart';
import 'package:mynotify/presentation/screens/authentication_screen.dart';
import 'package:mynotify/presentation/screens/home_screen.dart';
import 'package:mynotify/presentation/screens/welcome_screen.dart';

class AppRoutes {
  Route onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        );

      case '/auth':
        return MaterialPageRoute(
          builder: (_) => const AuthenticationScreen(),
        );
      case '/home':
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        );
      // case '/third':
      //   return MaterialPageRoute(
      //     builder: (_) => BlocProvider.value(
      //       value: _counterBloc,
      //       child: const ThirdScreen(title: 'Third'),
      //     ),
      //   );
      default:
        return MaterialPageRoute(
          builder: (_) => const WelcomeScreen(),
        );
    }
  }
}
