import 'package:flutter/material.dart';
import '../widgets/shimmer_loader.dart';

class NoInternetScreen extends StatelessWidget {
  final VoidCallback onRetry;

  const NoInternetScreen({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 60),
          const ShimmerLoader(),
          const SizedBox(height: 40),
          const Icon(Icons.wifi_off, size: 60, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('No Internet Connection', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
