import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_listing_app/core/theme/app_theme.dart';
import 'package:product_listing_app/features/auth/bloc/auth_bloc.dart';
import 'package:product_listing_app/features/auth/views/login_page.dart';
import 'package:product_listing_app/core/nav_bar/navbar_cubit.dart';
import 'package:product_listing_app/features/nav/nav_screen.dart';
import 'package:product_listing_app/features/splash/bloc/splash_bloc.dart';
import 'package:product_listing_app/features/splash/view/splash_screen.dart';
import 'package:product_listing_app/features/wishlist/bloc/wishlist_bloc.dart';
import 'package:product_listing_app/features/wishlist/bloc/wishlist_state.dart';
import 'package:product_listing_app/features/home/bloc/product_bloc.dart';
import 'package:product_listing_app/features/home/bloc/product_event.dart';
import 'package:product_listing_app/core/di/dependency_injection.dart' as di;
import 'package:product_listing_app/features/auth/repository/auth_repository.dart';
import 'package:product_listing_app/core/bloc/app_bloc_observer.dart';
import 'package:product_listing_app/features/home/repository/home_repository.dart';
import 'package:product_listing_app/features/wishlist/repository/wishlist_repository.dart';
import 'package:product_listing_app/features/profile/repository/profile_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize DI
  di.setupLocator().then((_) {
    Bloc.observer = AppBlocObserver();
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => di.sl<AuthRepository>(),
        ),
        RepositoryProvider(
          create: (context) => di.sl<HomeRepository>(),
        ),
        RepositoryProvider(
          create: (context) => di.sl<WishlistRepository>(),
        ),
        RepositoryProvider(
          create: (context) => di.sl<ProfileRepository>(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              context.read<AuthRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => HomeBloc(
              context.read<HomeRepository>(),
              wishlistRepository: context.read<WishlistRepository>(),
            )..add(LoadProducts()),
          ),
          BlocProvider(
            create: (context) => SplashBloc()..add(StartSplash()),
          ),
          BlocProvider(
            create: (context) =>
                NavigationCubit(), // Provide NavigationCubit globally
          ),
          BlocProvider(
            create: (context) => WishlistBloc(
              context.read<WishlistRepository>(),
            ),
          ),
        ],
        child: BlocListener<WishlistBloc, dynamic>(
          listener: (context, state) {
            if (state is WishlistLoaded) {
              final ids = state.products.map((p) => p.id).toSet();
              context.read<HomeBloc>().add(UpdateFavorites(ids));
            }
            if (state is WishlistError) {
              // You may want to show a snackbar here in production
            }
          },
          child: MaterialApp(
            title: 'Product Listing App',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            home: const SplashScreen(),
            routes: {
              '/login': (context) => const LoginScreen(),
              '/home': (context) => const NavScreen(),
            },
          ),
        ),
      ),
    );
  }
}
