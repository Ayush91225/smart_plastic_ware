import 'package:flutter/foundation.dart';

class ErrorHandler {
  static void logError(dynamic error, StackTrace? stackTrace) {
    if (kDebugMode) {
      print('Error: $error');
      if (stackTrace != null) print('StackTrace: $stackTrace');
    }
  }

  static void handleWebViewError(String url, int errorCode) {
    logError('WebView Error: $url - Code: $errorCode', null);
  }
}
