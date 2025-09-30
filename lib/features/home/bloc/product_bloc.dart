import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_listing_app/features/home/bloc/product_event.dart';
import 'package:product_listing_app/features/home/bloc/product_state.dart';
import 'package:product_listing_app/features/home/repository/home_repository.dart';
import 'package:product_listing_app/features/wishlist/repository/wishlist_repository.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository homeRepository;
  final WishlistRepository? wishlistRepository;

  HomeBloc(this.homeRepository, {this.wishlistRepository})
      : super(HomeInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<ToggleFavorite>(_onToggleFavorite);
    on<UpdateFavorites>(_onUpdateFavorites);
    on<SearchProducts>(_onSearchProducts);
  }

  Future<void> _onLoadProducts(
      LoadProducts event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      final products = await homeRepository.fetchProducts();
      final banners = await homeRepository.fetchBanners();

      // If wishlist repository is available, fetch wishlist and mark favorites
      if (wishlistRepository != null) {
        try {
          final wishlistProducts = await wishlistRepository!.fetchWishlist();
          final wishlistIds = wishlistProducts.map((p) => p.id).toSet();
          // Use immutable updates
          final updatedProducts = products
              .map((p) => p.copyWith(isFavorite: wishlistIds.contains(p.id)))
              .toList();
          // replace products reference with updated list
          // ignore: prefer_final_locals
          // (we can't reassign 'products' since it's final; instead use updatedProducts below)
          emit(HomeLoaded(
            popularProducts: updatedProducts,
            latestProducts: updatedProducts,
            banners: banners,
          ));
          return;
        } catch (_) {
          // ignore wishlist fetch errors here; we'll still show products
        }
      }

      // For simplicity, use all products as popular and latest
      emit(HomeLoaded(
        popularProducts: products,
        latestProducts: products,
        banners: banners,
      ));
    } catch (e) {
      emit(HomeError('Failed to load products'));
    }
  }

  void _onUpdateFavorites(UpdateFavorites event, Emitter<HomeState> emit) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;

      final updatedPopular = currentState.popularProducts
          .map((product) => product.copyWith(
              isFavorite: event.wishlistIds.contains(product.id)))
          .toList();

      final updatedLatest = currentState.latestProducts
          .map((product) => product.copyWith(
              isFavorite: event.wishlistIds.contains(product.id)))
          .toList();

      emit(HomeLoaded(
        popularProducts: updatedPopular,
        latestProducts: updatedLatest,
        banners: currentState.banners,
      ));
    }
  }

  void _onToggleFavorite(ToggleFavorite event, Emitter<HomeState> emit) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;

      final updatedPopular = currentState.popularProducts.map((product) {
        if (product.id == event.productId) {
          return product.copyWith(isFavorite: !product.isFavorite);
        }
        return product;
      }).toList();

      final updatedLatest = currentState.latestProducts.map((product) {
        if (product.id == event.productId) {
          return product.copyWith(isFavorite: !product.isFavorite);
        }
        return product;
      }).toList();

      emit(HomeLoaded(
        popularProducts: updatedPopular,
        latestProducts: updatedLatest,
        banners: currentState.banners,
      ));
    }
  }

  Future<void> _onSearchProducts(
      SearchProducts event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      final products = await homeRepository.searchProducts(event.query);
      emit(HomeLoaded(
        popularProducts: products,
        latestProducts: products,
        banners: [], // No banners for search
      ));
    } catch (e) {
      emit(HomeError('Failed to search products'));
    }
  }
}
