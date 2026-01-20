import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

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
      body: ListView(
        padding: const EdgeInsets.only(top: 20, bottom: 100),
        children: [
          _buildSection(
            'COMPANY',
            [
              _buildItem('About Us', 'https://smartplasticware.com/index.php?route=information/information&information_id=4'),
              _buildItem('Contact Us', 'https://smartplasticware.com/index.php?route=information/contact'),
            ],
          ),
          _buildSection(
            'POLICIES',
            [
              _buildItem('Delivery Information', 'https://smartplasticware.com/index.php?route=information/information&information_id=6'),
              _buildItem('Privacy Policy', 'https://smartplasticware.com/index.php?route=information/information&information_id=3'),
              _buildItem('Terms & Conditions', 'https://smartplasticware.com/index.php?route=information/information&information_id=5'),
              _buildDeleteAccountItem(),
            ],
          ),
          _buildSection(
            'CONTACT',
            [
              _buildContactItem(CupertinoIcons.phone, '+91 98290 28800', 'tel:919829028800'),
              _buildContactItem(CupertinoIcons.mail, 'Sdjm2305@gmail.com', 'mailto:Sdjm2305@gmail.com'),
              _buildContactItem(CupertinoIcons.location, 'Find us on Map', 'https://maps.app.goo.gl/FSnCZAGMhqxiRy9MA'),
            ],
          ),
          _buildSection(
            'SOCIAL',
            [
              _buildSocialItem('Facebook', 'https://facebook.com'),
              _buildSocialItem('Instagram', 'https://instagram.com'),
              _buildSocialItem('YouTube', 'https://youtube.com'),
            ],
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              'Smart Plastic Ware © 2026',
              style: TextStyle(
                fontSize: 12,
                color: Colors.black.withOpacity(0.4),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: GestureDetector(
              onTap: () => _launchUrl('https://syspoly.com/'),
              child: Text(
                'Powered by SYSPOLY',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black.withOpacity(0.4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black.withOpacity(0.5),
              letterSpacing: -0.1,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
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
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildItem(String title, String url) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () => _launchUrl(url),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.black.withOpacity(0.05),
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
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
    );
  }

  Widget _buildContactItem(IconData icon, String title, String url) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () => _launchUrl(url),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.black.withOpacity(0.05),
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: const Color(0xFFE2AF31)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
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
    );
  }

  Widget _buildSocialItem(String title, String url) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () => _launchUrl(url),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.black.withOpacity(0.05),
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
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
    );
  }

  Widget _buildDeleteAccountItem() {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () => _showDeleteAccountDialog(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            const Expanded(
              child: Text(
                'Delete Account',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.red,
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
    );
  }

  void _showDeleteAccountDialog() {
    // This would navigate to account deletion page on website
    _launchUrl('https://smartplasticware.com/index.php?route=account/delete');
  }
}
