import 'package:product_listing_app/features/home/models/product_models.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Product> popularProducts;
  final List<Product> latestProducts;
  final List<BannerModel> banners;

  HomeLoaded({
    required this.popularProducts,
    required this.latestProducts,
    required this.banners,
  });
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}
