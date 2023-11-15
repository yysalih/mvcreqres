import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mvcreqres/utilities/validators.dart';
import 'package:mvcreqres/view/auth/register_view.dart';
import 'package:mvcreqres/widgets/alert_dialogs.dart';
import '../../controllers/auth_controller.dart';
import '../home_view.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var authRead = ref.read(authController);
    var authWatch = ref.watch(authController);

    return Scaffold(
      body: Form(
        key: formKey,
        child: ListView(
          padding: EdgeInsets.all(10),
          children: [
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      label: Text("Email"),
                      hintText: "Email",
                      prefixIcon: const Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,

                    validator: AppValidators.emailValidator,
                  ),

                  SizedBox(height: 10,),

                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      label: Text("Password"),
                      hintText: "Password",
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        onPressed: () => authRead.passwordVisibility(),
                        icon: Icon(
                          authWatch.hidePassword
                              ? Icons.visibility_off
                              : Icons.remove_red_eye,
                        ),
                      ),
                    ),

                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
                    obscureText: authWatch.hidePassword,
                    validator: AppValidators.passwordValidator,
                  ),

                  SizedBox(height: 10,),

                  ElevatedButton.icon(
                    onPressed: () async => await login(),
                    icon: const Icon(Icons.login),
                    label: const Text("Login"),
                  ),

                  SizedBox(height: 10,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () => navigateToRegister(),
                        child: const Text("Sign Up"),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> login() async {
    if (formKey.currentState == null) return;
    if (!formKey.currentState!.validate()) return;

    String? message = await ref.read(authController).authentication(
      email: emailController.text,
      password: passwordController.text,
      isRegister: true,
    );

    if (message == null) {
      navigateToHome();
    } else {
      await showDialog(context: context, builder: (context) => AlertDialog(
        title: Text("Warning"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: navigateToHome,
            child: Text("Yes"),
          )
        ],
      ));
    }
  }

  void navigateToHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomeView()),
          (route) => false,
    );
  }

  void navigateToRegister() {
    ref.watch(authController).onDispose();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const RegisterView(),
      ),
    );
  }
}

final authController = ChangeNotifierProvider((ref) => AuthController());