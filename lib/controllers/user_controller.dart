import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvcreqres/constants.dart';
import 'package:mvcreqres/services/shared_preferences_service.dart';

import '../models/user_model.dart';
import '../services/api_service.dart';
import '../view/auth/login_view.dart';
import 'auth_controller.dart';

class UserController with ChangeNotifier {
  List<UserModel> _users = [];
  List<UserModel> get users => _users;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  Future<String?> getUsers() async {
    _isLoading = true;
    final String url = "${Constants.baseUrl}${Endpoint.users.name}";

    (List<UserModel>, String?) response =
    await ApiService.getDatas<UserModel>(
      url: url,
      model: const UserModel(),
      key: ResponseKeys.data.name,
    );

    _users = response.$1;
    _errorMessage = response.$2;
    _isLoading = false;

    notifyListeners();

    if (_errorMessage == null) return null;
    return _errorMessage;
  }

  Future<void> logout(BuildContext context) async {
    await SharedPreferencesService().delete(LocaleStorageKeys.token.name);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginView()),
      (route) => false,
    );
  }
}