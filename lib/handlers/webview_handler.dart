import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import '../services/error_handler.dart';

class WebViewHandler {
  late final WebViewController controller;

  WebViewHandler(String initialUrl) {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..enableZoom(false)
      ..setBackgroundColor(const Color(0xFFFFFFFF))
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            if (_shouldOpenExternally(request.url)) {
              _launchURL(request.url);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onWebResourceError: (error) {
            ErrorHandler.handleWebViewError(
              error.url ?? 'unknown',
              error.errorCode,
            );
          },
        ),
      )
      ..loadRequest(Uri.parse(initialUrl));
  }

  bool _shouldOpenExternally(String url) {
    return url.startsWith('tel:') ||
        url.startsWith('mailto:') ||
        url.startsWith('sms:') ||
        url.startsWith('whatsapp:') ||
        url.startsWith('upi:') ||
        url.startsWith('intent:') ||
        url.startsWith('paytm:') ||
        url.startsWith('phonepe:') ||
        url.startsWith('gpay:');
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> reload() => controller.reload();
  Future<bool> canGoBack() => controller.canGoBack();
  Future<void> goBack() => controller.goBack();
}
