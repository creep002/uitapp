// ignore_for_file: avoid_print

class AuthService {
  static final AuthService _instance = AuthService._internal();

  factory AuthService() {
    print("Creating AuthService instance");
    return _instance;
  }

  AuthService._internal() {
    print("AuthService _internal() constructor");
  }

  String? _token;

  String? get token => _token;

  setToken(String? token) {
    _token = token;
    print("Token set: $_token");
  }
}