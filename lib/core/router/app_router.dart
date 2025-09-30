import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_listing_app/features/auth/bloc/auth_bloc.dart';
import 'package:product_listing_app/features/auth/repository/auth_repository.dart';
import 'package:product_listing_app/features/auth/views/login_page.dart';
import 'package:product_listing_app/features/auth/views/name_entry_page.dart';
import 'package:product_listing_app/features/auth/views/otp_verification_page.dart';

import 'package:product_listing_app/features/home/bloc/product_bloc.dart';
import 'package:product_listing_app/features/home/repository/home_repository.dart';
import 'package:product_listing_app/features/home/views/home_page.dart';
import 'package:product_listing_app/features/nav/nav_screen.dart';
import 'package:product_listing_app/features/profile/bloc/profile_bloc.dart';
import 'package:product_listing_app/features/profile/repository/profile_repository.dart';
import 'package:product_listing_app/features/profile/views/profile_page.dart';
import 'package:product_listing_app/features/splash/bloc/splash_bloc.dart';
import 'package:product_listing_app/features/splash/view/splash_screen.dart';

import 'package:product_listing_app/features/wishlist/views/wishlist_page.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String otpVerification = '/otp-verification';
  static const String nameEntry = '/name-entry';
  static const String home = '/home';
  static const String nav = '/nav';
  static const String profile = '/profile';
  static const String wishlist = '/wishlist';
  static const String testNavigation = '/test-navigation';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => SplashBloc()..add(StartSplash()),
            child: const SplashScreen(),
          ),
        );

      case login:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => AuthBloc(
              RepositoryProvider.of<AuthRepository>(context),
            ),
            child: const LoginScreen(),
          ),
        );

      case otpVerification:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => AuthBloc(
              RepositoryProvider.of<AuthRepository>(context),
            ),
            child: OtpVerificationPage(
              phoneNumber: args?['phoneNumber'] ?? '',
            ),
          ),
        );

      case nameEntry:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => AuthBloc(
              RepositoryProvider.of<AuthRepository>(context),
            ),
            child: NameScreen(
              phoneNumber: args?['phoneNumber'] ?? '',
            ),
          ),
        );

      case home:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => HomeBloc(
              RepositoryProvider.of<HomeRepository>(context),
            ),
            child: const HomePage(),
          ),
        );

      case nav:
        return MaterialPageRoute(
          builder: (_) => const NavScreen(),
        );

      case profile:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => ProfileBloc(
              profileRepository:
                  RepositoryProvider.of<ProfileRepository>(context),
            ),
            child: const ProfilePage(),
          ),
        );

      case wishlist:
        return MaterialPageRoute(
          builder: (_) => const WishlistPage(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Page Not Found')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Page not found!'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(_, AppRoutes.login),
                    child: const Text('Go to Login'),
                  ),
                ],
              ),
            ),
          ),
        );
    }
  }

  // Helper method to navigate to any page
  static void navigateTo(BuildContext context, String routeName,
      {Object? arguments}) {
    Navigator.pushNamed(context, routeName, arguments: arguments);
  }

  // Helper method to replace current page
  static void replaceWith(BuildContext context, String routeName,
      {Object? arguments}) {
    Navigator.pushReplacementNamed(context, routeName, arguments: arguments);
  }

  // Helper method to navigate and remove all previous routes
  static void navigateAndClear(BuildContext context, String routeName,
      {Object? arguments}) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }
}
