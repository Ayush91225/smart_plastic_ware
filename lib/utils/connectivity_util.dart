import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityUtil {
  static Future<bool> hasConnection() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  static Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      Connectivity().onConnectivityChanged.map((result) => [result]);
}
