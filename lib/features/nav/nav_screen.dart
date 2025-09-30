// lib/presentation/nav/nav_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_listing_app/features/home/views/home_page.dart';
import 'package:product_listing_app/features/nav/widget/bottom_nav_bar.dart';
import 'package:product_listing_app/features/profile/views/profile_page.dart';
import 'package:product_listing_app/features/wishlist/views/wishlist_page.dart';
import 'package:product_listing_app/core/nav_bar/navbar_cubit.dart';

class NavScreen extends StatelessWidget {
  const NavScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const List<Widget> pages = [
      HomePage(),
      WishlistPage(),
      ProfilePage(),
    ];

    return BlocBuilder<NavigationCubit, int>(
      builder: (context, state) {
        return Scaffold(
          body: pages[state],
          bottomNavigationBar: const BottomNavBar(),
        );
      },
    );
  }
}
