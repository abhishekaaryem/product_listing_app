import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:product_listing_app/features/home/bloc/product_bloc.dart';
import 'package:product_listing_app/features/home/bloc/product_event.dart';
import 'package:product_listing_app/features/home/bloc/product_state.dart';
import 'package:product_listing_app/features/home/widgets/product_card.dart';
import 'package:product_listing_app/features/wishlist/bloc/wishlist_bloc.dart';
import 'package:product_listing_app/features/wishlist/bloc/wishlist_event.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  Timer? _bannerTimer;
  int _currentBanner = 0;

  @override
  void initState() {
    super.initState();
  }

  void _startAutoScroll() {
    _bannerTimer?.cancel();
    _bannerTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted) return;
      // Advance to next banner based on current HomeBloc banners length
      if (_pageController.hasClients) {
        final blocState = context.read<HomeBloc>().state;
        if (blocState is HomeLoaded && blocState.banners.isNotEmpty) {
          final next = (_currentBanner + 1) % blocState.banners.length;
          _pageController.animateToPage(
            next,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Content
            Expanded(
              child: BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  if (state is HomeLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is HomeLoaded) {
                    return _buildContent(context, state);
                  } else if (state is HomeError) {
                    return Center(child: Text(state.message));
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, HomeLoaded state) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: const TextStyle(
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    height: 30 / 14, // line-height / font-size
                    letterSpacing: 0,
                  ),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SvgPicture.asset(
                      'assets/icons/search.svg',
                      width: 25,
                      height: 25,
                      colorFilter: ColorFilter.mode(
                        Colors.grey.shade600,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
                onSubmitted: (query) {
                  if (query.isNotEmpty) {
                    context.read<HomeBloc>().add(SearchProducts(query));
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Banner - PageView carousel
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              height: 160,
              child: BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  final banners = state is HomeLoaded ? state.banners : [];
                  if (banners.isEmpty) {
                    // If no banners, ensure timer is cancelled to avoid pending timers in tests
                    _bannerTimer?.cancel();
                    _bannerTimer = null;
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue.shade50,
                            Colors.purple.shade50,
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Panggon Kitchen - Lalu Mall',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'Flat 50% Off!',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(16),
                                  bottomRight: Radius.circular(16),
                                ),
                                child: Container(
                                  width: 120,
                                  padding: const EdgeInsets.all(10),
                                  child: Image.network(
                                    'https://via.placeholder.com/150',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }

                  // Start auto-scroll only when we have banners and timer isn't running
                  if (_bannerTimer == null && banners.isNotEmpty) {
                    _startAutoScroll();
                  }

                  return Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      PageView.builder(
                        controller: _pageController,
                        itemCount: banners.length,
                        onPageChanged: (index) => setState(() {
                          _currentBanner = index;
                        }),
                        itemBuilder: (context, index) {
                          final b = banners[index];
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              b.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                color: Colors.grey.shade200,
                                child: const Center(child: Icon(Icons.image)),
                              ),
                            ),
                          );
                        },
                      ),
                      Positioned(
                        bottom: 8,
                        child: Row(
                          children: List.generate(
                            banners.length,
                            (i) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: _currentBanner == i ? 20 : 8,
                              height: 6,
                              decoration: BoxDecoration(
                                color: _currentBanner == i
                                    ? Colors.blue
                                    : Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Popular Products
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Popular Product',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.7,
              ),
              itemCount: state.popularProducts.length,
              itemBuilder: (context, index) {
                final product = state.popularProducts[index];
                return ProductCard(
                  product: product,
                  onFavoritePressed: () {
                    // Update UI state in HomeBloc
                    context.read<HomeBloc>().add(ToggleFavorite(product.id));
                    // Call wishlist add/remove API via WishlistBloc
                    try {
                      context
                          .read<WishlistBloc>()
                          .add(ToggleWishlist(product.id));
                    } catch (_) {
                      // If WishlistBloc is not provided, fail silently to avoid crashes
                    }
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          // Latest Products
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Latest Products',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.7,
              ),
              itemCount: state.latestProducts.length,
              itemBuilder: (context, index) {
                final product = state.latestProducts[index];
                return ProductCard(
                  product: product,
                  onFavoritePressed: () {
                    // Update UI state in HomeBloc
                    context.read<HomeBloc>().add(ToggleFavorite(product.id));
                    // Call wishlist add/remove API via WishlistBloc
                    try {
                      context
                          .read<WishlistBloc>()
                          .add(ToggleWishlist(product.id));
                    } catch (_) {
                      // If WishlistBloc is not provided, fail silently to avoid crashes
                    }
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
