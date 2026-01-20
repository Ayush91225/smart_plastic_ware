import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';

class CategoriesScreen extends StatefulWidget {
  final Function(String) onCategorySelected;

  const CategoriesScreen({super.key, required this.onCategorySelected});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final List<Map<String, String>> _categories = [
    {'name': 'Bath Mates', 'url': 'https://smartplasticware.com/index.php?route=product/category&path=59'},
    {'name': 'BATHROOM SETS', 'url': 'https://smartplasticware.com/index.php?route=product/category&path=60'},
    {'name': 'Garbage bins & cleaning', 'url': 'https://smartplasticware.com/index.php?route=product/category&path=62'},
    {'name': 'Laundry basket', 'url': 'https://smartplasticware.com/index.php?route=product/category&path=63'},
    {'name': 'Patlas & Stools', 'url': 'https://smartplasticware.com/index.php?route=product/category&path=61'},
  ];

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: const Color(0xFFF2F2F7),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(44),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.85),
                border: Border(
                  bottom: BorderSide(
                    color: Colors.black.withOpacity(0.1),
                    width: 0.3,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 20),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildCategoryItem(category, index),
          );
        },
      ),
    );
  }

  Widget _buildCategoryItem(Map<String, String> category, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () => widget.onCategorySelected(category['url']!),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  category['name']!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
              const Icon(
                CupertinoIcons.chevron_right,
                color: Color(0xFFC7C7CC),
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
