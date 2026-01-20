import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoader extends StatelessWidget {
  const ShimmerLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          _buildShimmerBox(height: 200),
          const SizedBox(height: 16),
          _buildShimmerBox(height: 100),
          const SizedBox(height: 16),
          _buildShimmerBox(height: 150),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildShimmerBox(height: 80)),
              const SizedBox(width: 16),
              Expanded(child: _buildShimmerBox(height: 80)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerBox({required double height}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
