import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mvcreqres/constants.dart';

import '../../controllers/auth_controller.dart';
import '../../utilities/validators.dart';
import '../../widgets/alert_dialogs.dart';
import '../home_view.dart';

class RegisterView extends ConsumerStatefulWidget {
  const RegisterView({super.key});

  @override
  ConsumerState<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends ConsumerState<RegisterView> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var authRead = ref.read(authController);
    var authWatch = ref.watch(authController);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: EdgeInsets.all(10),
          children: [


            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "Email",
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
                labelText: "Password",
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
              textInputAction: TextInputAction.next,
              obscureText: authWatch.hidePassword,
              validator: AppValidators.passwordValidator,
            ),

            SizedBox(height: 10,),

            TextFormField(
              controller: confirmPasswordController,
              decoration: InputDecoration(
                labelText: "Confirm Password",
                hintText: "Confirm Password",
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  onPressed: () => authRead.confirmPasswordVisibility(),
                  icon: Icon(
                    authWatch.hideConfirmPassword
                        ? Icons.visibility_off
                        : Icons.remove_red_eye,
                  ),
                ),
              ),

              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.done,
              obscureText: authWatch.hideConfirmPassword,
              validator: (value) => AppValidators.confirmPasswordValidator(
                passwordController.text,
                value,
              ),
            ),

            SizedBox(height: 10,),

            ElevatedButton.icon(
              onPressed: () async => await register(),
              icon: const Icon(Icons.login),
              label: const Text("Register"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> register() async {
    if (formKey.currentState == null) return;
    if (!formKey.currentState!.validate()) return;

    String? errorMessage = await ref.read(authController).authentication(
      email: emailController.text,
      password: passwordController.text,
      isRegister: true,
    );

    await showDialog(context: context, builder: (context) => AlertDialog(
      title: Text("Warning"),
      content: Text(errorMessage ?? Constants.succesfulRegistration),
      actions: [
        TextButton(
          onPressed: errorMessage == null ? navigateToHome : null,
          child: Text("Yes"),
        )
      ],
    ));
  }

  void navigateToHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomeView()),
          (route) => false,
    );
  }
}
final authController = ChangeNotifierProvider((ref) => AuthController());