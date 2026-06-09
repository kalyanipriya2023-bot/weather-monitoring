library;

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/app_constants.dart';
import '../core/app_exceptions.dart';
import '../database/database_helper.dart';
import '../models/user_model.dart';

class AuthService {
  final DatabaseHelper _db = DatabaseHelper();

  String _hashPassword(String password) {
    // Simple hash for local-only auth demo
    final bytes = utf8.encode(password);
    return base64Encode(bytes);
  }

  Future<UserModel> register(String name, String email, String password) async {
    // Check if email already exists
    final existing = await _db.query('users', where: 'email = ?', whereArgs: [email]);
    if (existing.isNotEmpty) {
      throw const AuthException('Email already registered');
    }
    final user = UserModel(
      name: name, email: email,
      passwordHash: _hashPassword(password),
      createdAt: DateTime.now(),
    );
    final id = await _db.insert('users', user.toMap());
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(kUserIdKey, id);
    await prefs.setBool(kIsGuestKey, false);
    return UserModel(id: id, name: name, email: email, passwordHash: user.passwordHash, createdAt: user.createdAt);
  }

  Future<UserModel> login(String email, String password) async {
    final results = await _db.query('users', where: 'email = ?', whereArgs: [email]);
    if (results.isEmpty) {
      throw const AuthException('No account found with this email');
    }
    final user = UserModel.fromMap(results.first);
    if (user.passwordHash != _hashPassword(password)) {
      throw const AuthException('Incorrect password');
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(kUserIdKey, user.id!);
    await prefs.setBool(kIsGuestKey, false);
    return user;
  }

  Future<UserModel> loginAsGuest() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(kIsGuestKey, true);
    await prefs.remove(kUserIdKey);
    return UserModel.guest();
  }

  Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final isGuest = prefs.getBool(kIsGuestKey) ?? false;
    if (isGuest) return UserModel.guest();
    final userId = prefs.getInt(kUserIdKey);
    if (userId == null) return null;
    final results = await _db.query('users', where: 'id = ?', whereArgs: [userId]);
    if (results.isEmpty) return null;
    return UserModel.fromMap(results.first);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(kUserIdKey);
    await prefs.remove(kIsGuestKey);
  }

  Future<void> resetPassword(String email, String newPassword) async {
    final results = await _db.query('users', where: 'email = ?', whereArgs: [email]);
    if (results.isEmpty) throw const AuthException('No account found with this email');
    await _db.update('users', {'passwordHash': _hashPassword(newPassword)},
      where: 'email = ?', whereArgs: [email]);
  }
}
