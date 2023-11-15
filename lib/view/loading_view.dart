import 'package:flutter/material.dart';
import 'package:mvcreqres/services/shared_preferences_service.dart';

import '../controllers/auth_controller.dart';
import 'auth/login_view.dart';
import 'home_view.dart';


class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  Future<void> getSharedPreferences(BuildContext context) async {
    String? token = await SharedPreferencesService().get(LocaleStorageKeys.token.name);
    print("Token: $token");
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => token == null ? const LoginView() : const HomeView(),
      ),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getSharedPreferences(context),
        builder: (context, snapshot) {
          return const Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 10,),
                Text("Welcome")
              ],
            ),
          );
        },
      ),
    );
  }
}

