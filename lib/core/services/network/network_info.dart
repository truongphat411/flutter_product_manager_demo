import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkInfo {
  static final NetworkInfo _instance = NetworkInfo._internal();

  static NetworkInfo get instance => _instance;

  final Connectivity _connectivity = Connectivity();

  NetworkInfo._internal();

  Future<bool> get isConnected async {
    final results = await _connectivity.checkConnectivity();
    return results.isNotEmpty && !results.contains(ConnectivityResult.none);
  }
}
