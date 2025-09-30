import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:product_listing_app/core/utils/network_utils.dart';

class ConnectivityChecker extends StatelessWidget {
  final Widget child;

  const ConnectivityChecker({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ConnectivityResult>(
      stream: NetworkUtils.onConnectivityChanged,
      builder: (context, snapshot) {
        final isConnected = snapshot.data != ConnectivityResult.none;
        
        return Column(
          children: [
            if (!isConnected)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                color: Colors.red,
                child: const Text(
                  'No internet connection',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            Expanded(child: child),
          ],
        );
      },
    );
  }
}

/// Utility function to show connectivity status
void showConnectivityStatus(BuildContext context, bool isConnected) {
  if (!isConnected) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('No internet connection. Please check your network settings.'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }
}