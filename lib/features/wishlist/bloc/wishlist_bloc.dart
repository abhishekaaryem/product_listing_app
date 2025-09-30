import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_listing_app/features/wishlist/bloc/wishlist_event.dart';
import 'package:product_listing_app/features/wishlist/bloc/wishlist_state.dart';
import 'package:product_listing_app/features/wishlist/repository/wishlist_repository.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  final WishlistRepository wishlistRepository;

  WishlistBloc(this.wishlistRepository) : super(WishlistInitial()) {
    on<LoadWishlist>(_onLoadWishlist);
    on<ToggleWishlist>(_onToggleWishlist);
  }

  Future<void> _onLoadWishlist(
      LoadWishlist event, Emitter<WishlistState> emit) async {
    emit(WishlistLoading());
    try {
      final products = await wishlistRepository.fetchWishlist();
      // Ensure wishlist products are marked as favorite using immutable copy
      final updated =
          products.map((p) => p.copyWith(isFavorite: true)).toList();
      emit(WishlistLoaded(updated));
    } catch (e) {
      emit(WishlistError('Failed to load wishlist'));
    }
  }

  Future<void> _onToggleWishlist(
      ToggleWishlist event, Emitter<WishlistState> emit) async {
    try {
      await wishlistRepository.addOrRemoveWishlist(event.productId);
      // Reload wishlist after toggle
      add(LoadWishlist());
    } catch (e) {
      emit(WishlistError('Failed to update wishlist'));
    }
  }
}
