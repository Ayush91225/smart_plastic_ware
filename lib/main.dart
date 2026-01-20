import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'dart:ui';
import 'screens/webview_screen.dart';
import 'screens/categories_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/no_internet_screen.dart';
import 'utils/connectivity_util.dart';
import 'utils/constants.dart';
import 'services/cache_service.dart';
import 'services/error_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFFE2AF31),
        scaffoldBackgroundColor: const Color(0xFFF2F2F7),
        fontFamily: '.SF Pro Text',
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  bool _hasInternet = true;
  String? _categoryUrl;
  int _cartRefreshKey = 0;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    ConnectivityUtil.onConnectivityChanged.listen((_) => _checkConnectivity());
  }

  Future<void> _checkConnectivity() async {
    final hasConnection = await ConnectivityUtil.hasConnection();
    setState(() => _hasInternet = hasConnection);
  }

  void _onCategorySelected(String url) {
    setState(() {
      _categoryUrl = url;
      _selectedIndex = 0;
    });
  }

  Widget _buildHomeTab() {
    return WebViewScreen(
      key: ValueKey(_categoryUrl ?? 'home'),
      initialUrl: _categoryUrl ?? AppConstants.baseUrl,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      extendBody: true,
      body: _hasInternet
          ? IndexedStack(
              index: _selectedIndex,
              children: [
                _buildHomeTab(),
                CategoriesScreen(onCategorySelected: _onCategorySelected),
                WebViewScreen(
                  key: ValueKey('cart_$_cartRefreshKey'),
                  initialUrl: 'https://smartplasticware.com/index.php?route=checkout/cart',
                ),
                const SettingsScreen(),
              ],
            )
          : NoInternetScreen(onRetry: _checkConnectivity),
      bottomNavigationBar: _hasInternet
          ? ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
                    border: Border(
                      top: BorderSide(
                        color: Colors.black.withOpacity(0.1),
                        width: 0.3,
                      ),
                    ),
                  ),
                  child: SafeArea(
                    child: SizedBox(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildNavItem(CupertinoIcons.home, 'Home', 0),
                          _buildNavItem(CupertinoIcons.square_grid_2x2, 'Categories', 1),
                          _buildNavItem(CupertinoIcons.cart, 'Cart', 2),
                          _buildNavItem(CupertinoIcons.settings, 'Settings', 3),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;
    return Expanded(
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          if (index == 2) {
            setState(() => _cartRefreshKey++);
          }
          setState(() => _selectedIndex = index);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFFE2AF31) : const Color(0xFF8E8E93),
              size: 26,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: isSelected ? const Color(0xFFE2AF31) : const Color(0xFF8E8E93),
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
