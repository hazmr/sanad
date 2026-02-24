import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../models/user_model.dart';

enum AuthState { initial, loading, authenticated, unauthenticated, error }

class AuthProvider extends ChangeNotifier {
  AuthState _state = AuthState.initial;
  UserModel? _user;
  String? _error;
  String? _accessToken;
  String? _refreshToken;
  
  AuthState get state => _state;
  UserModel? get user => _user;
  String? get error => _error;
  String? get accessToken => _accessToken;
  bool get isAuthenticated => _state == AuthState.authenticated;
  bool get isDoctor => _user?.role == 'Doctor';
  bool get isPatient => _user?.role == 'Patient';
  
  final ApiService _apiService = ApiService();
  
  AuthProvider() {
    _checkAuth();
  }
  
  Future<void> _checkAuth() async {
    final prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString('accessToken');
    _refreshToken = prefs.getString('refreshToken');
    
    if (_accessToken != null) {
      // Try to get user profile
      try {
        final userData = prefs.getString('userData');
        if (userData != null) {
          _user = UserModel.fromJsonString(userData);
          _state = AuthState.authenticated;
        } else {
          _state = AuthState.unauthenticated;
        }
      } catch (e) {
        _state = AuthState.unauthenticated;
      }
    } else {
      _state = AuthState.unauthenticated;
    }
    notifyListeners();
  }
  
  Future<bool> login(String phoneNumber, String password) async {
    _state = AuthState.loading;
    _error = null;
    notifyListeners();
    
    try {
      final response = await _apiService.login(phoneNumber, password);
      
      if (response != null) {
        // API returns: userId, name, role, token, refreshToken
        _accessToken = response['token'];
        _refreshToken = response['refreshToken'];
        
        // Parse user data from response (flat structure, not nested)
        _user = UserModel(
          id: response['userId'],
          name: response['name'],
          phoneNumber: phoneNumber, // Use the phone number we logged in with
          role: response['role'],
        );
        
        // Save to preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', _accessToken!);
        await prefs.setString('refreshToken', _refreshToken!);
        await prefs.setString('userData', _user!.toJsonString());
        
        _state = AuthState.authenticated;
        notifyListeners();
        return true;
      } else {
        _error = 'Invalid credentials';
        _state = AuthState.error;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      _state = AuthState.error;
      notifyListeners();
      return false;
    }
  }
  
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
    await prefs.remove('userData');
    
    _accessToken = null;
    _refreshToken = null;
    _user = null;
    _state = AuthState.unauthenticated;
    notifyListeners();
  }
  
  Future<bool> refreshAccessToken() async {
    if (_refreshToken == null || _accessToken == null) return false;
    
    try {
      final response = await _apiService.refreshToken(_accessToken!, _refreshToken!);
      
      if (response != null) {
        // API returns: token, refreshToken (not accessToken)
        _accessToken = response['token'];
        _refreshToken = response['refreshToken'];
        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', _accessToken!);
        await prefs.setString('refreshToken', _refreshToken!);
        
        return true;
      }
    } catch (e) {
      await logout();
    }
    return false;
  }
}
