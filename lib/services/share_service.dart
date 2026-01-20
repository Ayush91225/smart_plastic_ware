import 'package:share_plus/share_plus.dart';

class ShareService {
  static Future<void> shareProduct(String productUrl, String productName) async {
    await Share.share(
      'Check out $productName on Smart Plastic Ware!\n$productUrl',
      subject: productName,
    );
  }

  static Future<void> shareText(String text) async {
    await Share.share(text);
  }
}
