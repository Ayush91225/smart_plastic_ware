import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'dart:ui';
import 'package:webview_flutter/webview_flutter.dart';
import '../handlers/webview_handler.dart';
import '../utils/constants.dart';
import '../widgets/shimmer_loader.dart';
import '../services/cache_service.dart';
import '../services/share_service.dart';

class WebViewScreen extends StatefulWidget {
  final String? initialUrl;

  const WebViewScreen({super.key, this.initialUrl});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late WebViewHandler _handler;
  bool _isLoading = true;
  bool _isInitialLoad = true;
  late UniqueKey _key;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  @override
  void didUpdateWidget(WebViewScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialUrl != widget.initialUrl) {
      _initializeWebView();
    }
  }

  void _initializeWebView() {
    _key = UniqueKey();
    final url = widget.initialUrl ?? AppConstants.baseUrl;
    _handler = WebViewHandler(url);
    _handler.controller
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            if (_isInitialLoad) {
              setState(() => _isLoading = true);
            }
            CacheService.saveLastUrl(url);
          },
          onPageFinished: (_) {
            _hideFooter();
            _disableTextSelection();
            _injectShareButton();
            _injectFileUploadHandler();
            setState(() {
              _isLoading = false;
              _isInitialLoad = false;
            });
          },
          onWebResourceError: (error) {
            print('WebView Error: ${error.description}');
            setState(() => _isLoading = false);
          },
        ),
      )
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'FlutterAlert',
        onMessageReceived: (message) {
          _showAlert(message.message);
        },
      )
      ..addJavaScriptChannel(
        'FlutterShare',
        onMessageReceived: (message) {
          _handleShare(message.message);
        },
      )
      ..runJavaScript('''
        window.alert = function(message) {
          FlutterAlert.postMessage(message);
        };
      ''');
  }

  Future<void> _hideFooter() async {
    await _handler.controller.runJavaScript('''
      const footer = document.querySelector('footer');
      if (footer) footer.style.display = 'none';
    ''');
  }

  Future<void> _disableTextSelection() async {
    await _handler.controller.runJavaScript('''
      document.body.style.userSelect = 'none';
      document.body.style.webkitUserSelect = 'none';
      document.body.style.webkitTouchCallout = 'none';
    ''');
  }

  Future<void> _injectShareButton() async {
    await _handler.controller.runJavaScript('''
      window.shareProduct = function(url, title) {
        FlutterShare.postMessage(JSON.stringify({url: url, title: title}));
      };
    ''');
  }

  Future<void> _injectFileUploadHandler() async {
    await _handler.controller.runJavaScript('''
      document.addEventListener('click', function(e) {
        if (e.target.tagName === 'INPUT' && e.target.type === 'file') {
          e.preventDefault();
          FlutterShare.postMessage(JSON.stringify({action: 'file_upload'}));
        }
      });
    ''');
  }

  void _handleShare(String message) {
    try {
      final data = message.contains('{') ? message : '{}';
      ShareService.shareText(message);
    } catch (e) {
      print('Share error: $e');
    }
  }

  void _showAlert(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _refresh() async {
    await _handler.reload();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: Platform.isIOS
          ? PreferredSize(
              preferredSize: Size.fromHeight(topPadding + 44),
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: EdgeInsets.only(top: topPadding),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.withOpacity(0.2),
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        CupertinoButton(
                          padding: const EdgeInsets.only(left: 8),
                          onPressed: () async {
                            if (await _handler.canGoBack()) {
                              _handler.goBack();
                            } else {
                              await _handler.controller.loadRequest(Uri.parse(AppConstants.baseUrl));
                            }
                          },
                          child: const Icon(CupertinoIcons.back, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          : null,
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;
          if (await _handler.canGoBack()) {
            _handler.goBack();
          }
        },
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: Platform.isIOS ? topPadding + 44 : 0),
              child: WebViewWidget(key: _key, controller: _handler.controller),
            ),
            if (_isLoading)
              Padding(
                padding: EdgeInsets.only(top: Platform.isIOS ? topPadding + 44 : 0),
                child: Container(
                  color: Colors.white,
                  child: const ShimmerLoader(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
