import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_listing_app/features/wishlist/bloc/wishlist_bloc.dart';
import 'package:product_listing_app/features/wishlist/bloc/wishlist_event.dart';
import 'package:product_listing_app/features/wishlist/bloc/wishlist_state.dart';
import 'package:product_listing_app/features/home/widgets/product_card.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  @override
  void initState() {
    super.initState();
    context.read<WishlistBloc>().add(LoadWishlist());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Wishlist'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocBuilder<WishlistBloc, WishlistState>(
        builder: (context, state) {
          if (state is WishlistLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is WishlistLoaded) {
            if (state.products.isEmpty) {
              return const Center(
                child: Text('No items in wishlist'),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.7,
                ),
                itemCount: state.products.length,
                itemBuilder: (context, index) {
                  final product = state.products[index];
                  return ProductCard(
                    product: product,
                    onFavoritePressed: () {
                      context
                          .read<WishlistBloc>()
                          .add(ToggleWishlist(product.id));
                    },
                  );
                },
              ),
            );
          } else if (state is WishlistError) {
            return Center(
              child: Text('Error: ${state.message}'),
            );
          }
          return const Center(child: Text('Wishlist'));
        },
      ),
    );
  }
}
