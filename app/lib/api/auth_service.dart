import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';

class AuthService {
  // Singleton
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  late final PocketBase _pb = PocketBase(
    (!kIsWeb && Platform.isAndroid) ? 'http://10.0.2.2:8090' : 'http://127.0.0.1:8090',
  );

  PocketBase get pb => _pb;

  bool get isLoggedIn => _pb.authStore.isValid;

  /// Connexion avec email et mot de passe
  Future<void> login(String email, String password) async {
    await _pb.collection('users').authWithPassword(email, password);
  }

  /// Inscription puis connexion automatique
  Future<void> register(String email, String password) async {
    await _pb.collection('users').create(body: {
      'email': email,
      'password': password,
      'passwordConfirm': password,
    });
    await login(email, password);
  }

  /// Déconnexion
  void logout() {
    _pb.authStore.clear();
  }
}
