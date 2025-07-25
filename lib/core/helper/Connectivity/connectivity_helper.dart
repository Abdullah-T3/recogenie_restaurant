import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityHelper {
  static final Connectivity _connectivity = Connectivity();

  /// Returns `true` if connected, `false` otherwise.
  static Future<bool> isConnected() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();

      // If not connected to any network
      if (connectivityResult == ConnectivityResult.none) {
        return false;
      }

      // Additional check by pinging Google
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Yields `true` if connected, `false` otherwise.
  static Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map((event) {
      return event != ConnectivityResult.none;
    });
  }
}
