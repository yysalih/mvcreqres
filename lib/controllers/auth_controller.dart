import 'package:flutter/material.dart';
import 'package:mvcreqres/constants.dart';
import 'package:mvcreqres/services/shared_preferences_service.dart';
import '../models/auth_response_model.dart';
import '../services/api_service.dart';

enum Endpoint { login, register, users }
enum ResponseKeys { data, token, error }
enum LocaleStorageKeys { token }

final class AuthController with ChangeNotifier {
  bool _hidePassword = true;
  bool get hidePassword => _hidePassword;

  bool _hideConfrimPassword = true;
  bool get hideConfirmPassword => _hideConfrimPassword;

  AuthResponseModel _authResponseModel = const AuthResponseModel();
  AuthResponseModel get authResponseModel => _authResponseModel;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void passwordVisibility() {
    _hidePassword = !_hidePassword;
    notifyListeners();
  }

  void confirmPasswordVisibility() {
    _hideConfrimPassword = !_hideConfrimPassword;
    notifyListeners();
  }

  Future<String?> authentication({
    required String email,
    required String password,
    bool isRegister = false
  }) async {

    Map<String, dynamic> body = {
      "email": email,
      "password": password,
    };

    final String url = isRegister
        ? "${Constants.baseUrl}register"
        : "${Constants.baseUrl}login"; //TODO girişte hata çıkabilir

    (AuthResponseModel, String?) response = await ApiService.postData<AuthResponseModel>(
      url: url,
      model: _authResponseModel,
      body: body,
    );

    _authResponseModel = response.$1;
    _errorMessage = response.$2;

    await _saveToLocale();

    notifyListeners();

    if (_errorMessage == null) return null;
    return _errorMessage;
  }


  Future<void> _saveToLocale() async {
    if (_authResponseModel.token == null) {
      print("token is null");
      return;
    }
    print(_authResponseModel.token!);
    await SharedPreferencesService().set<String>(
      key: LocaleStorageKeys.token.name,
      value: _authResponseModel.token!,
    );
  }

  void onDispose() {
    _hidePassword = true;
    _hideConfrimPassword = true;
    _authResponseModel = const AuthResponseModel();
    _errorMessage = null;
    notifyListeners();
  }
}