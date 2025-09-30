import 'package:get_it/get_it.dart';
import 'package:product_listing_app/features/auth/repository/auth_repository.dart';
import 'package:product_listing_app/features/home/repository/home_repository.dart';
import 'package:product_listing_app/features/wishlist/repository/wishlist_repository.dart';
import 'package:product_listing_app/features/profile/repository/profile_repository.dart';

final GetIt sl = GetIt.instance;

/// Registers singleton instances for repositories and services used across the app.
Future<void> setupLocator() async {
  // Repositories
  if (!sl.isRegistered<AuthRepository>()) {
    sl.registerLazySingleton<AuthRepository>(() => AuthRepository());
  }

  if (!sl.isRegistered<HomeRepository>()) {
    sl.registerLazySingleton<HomeRepository>(() => HomeRepository());
  }

  if (!sl.isRegistered<WishlistRepository>()) {
    sl.registerLazySingleton<WishlistRepository>(() => WishlistRepository());
  }

  if (!sl.isRegistered<ProfileRepository>()) {
    sl.registerLazySingleton<ProfileRepository>(() => ProfileRepository());
  }
}
