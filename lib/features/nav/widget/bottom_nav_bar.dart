// lib/presentation/nav/widgets/bottom_nav_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:product_listing_app/core/nav_bar/navbar_cubit.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, int>(
      builder: (context, state) {
        return CustomBottomNavBar(currentIndex: state);
      },
    );
  }
}

class CustomBottomNavBar extends StatefulWidget {
  final int currentIndex;

  const CustomBottomNavBar({Key? key, required this.currentIndex})
      : super(key: key);

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  // We'll animate a pill under the active item. We'll compute alignment based on index.
  double _alignmentForIndex(int index) {
    switch (index) {
      case 0:
        return -1.0; // left
      case 1:
        return 0.0; // center
      case 2:
        return 1.0; // right
      default:
        return -1.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final current = widget.currentIndex;
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: SizedBox(
        height: 75,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 75,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(45),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.1),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                    spreadRadius: 5,
                  ),
                ],
              ),
            ),
            // Animated pill
            AnimatedAlign(
              alignment: Alignment(_alignmentForIndex(current), 0),
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeInOut,
              child: Container(
                width: MediaQuery.of(context).size.width / 3 - 24,
                height: 56,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF6C63FF),
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
            ),
            // Items row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavBarButton(
                  icon: Icons.home_rounded,
                  label: 'Home',
                  index: 0,
                  activeIndex: current,
                  onTap: () => context.read<NavigationCubit>().changeTab(0),
                ),
                _NavBarButton(
                  icon: Icons.favorite_rounded,
                  label: 'Wishlist',
                  index: 1,
                  activeIndex: current,
                  onTap: () => context.read<NavigationCubit>().changeTab(1),
                ),
                _NavBarButton(
                  icon: Icons.person_rounded,
                  label: 'Profile',
                  index: 2,
                  activeIndex: current,
                  onTap: () => context.read<NavigationCubit>().changeTab(2),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NavBarButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int activeIndex;
  final VoidCallback onTap;

  const _NavBarButton({
    required this.icon,
    required this.label,
    required this.index,
    required this.activeIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = index == activeIndex;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(40),
        child: SizedBox(
          height: 75,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon,
                    color: isActive ? Colors.white : Colors.grey, size: 24),
                if (isActive) ...[
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
