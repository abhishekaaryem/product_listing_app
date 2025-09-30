abstract class WishlistEvent {}

class LoadWishlist extends WishlistEvent {}

class ToggleWishlist extends WishlistEvent {
  final String productId;
  ToggleWishlist(this.productId);
}
