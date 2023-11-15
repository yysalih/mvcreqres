import 'package:flutter/material.dart';
import 'package:mvcreqres/constants.dart';


final class AppValidators {

  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return Constants.emptyEmail;
    }

    else {
      return null;
    }
  }


  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return Constants.emptyPassword;
    } else {
      return null;
    }
  }

  static String? confirmPasswordValidator(
      String? password, String? confirmPassword) {
    if (password == null || password.isEmpty) {
      return Constants.emptyPassword;
    } else if (password != confirmPassword) {
      return Constants.unmatchedPasswords;
    }
    return null;
  }
}