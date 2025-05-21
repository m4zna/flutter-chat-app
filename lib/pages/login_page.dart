import 'package:chat/widgets/blue_button.dart';
import 'package:chat/widgets/custom_input.dart';
import 'package:chat/widgets/labels.dart';
import 'package:chat/widgets/logo.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.85,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Logo(title: 'Messenger'),
                _Form(),
                Labels(route: 'register', title: '¿No tienes cuenta?', subtitle: 'Crea una ahora!'),
                const Text(
                  'Terminos y condiciones de uso',
                  style: TextStyle(fontWeight: FontWeight.w200),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  @override
  State<_Form> createState() => _FormState();
}

class _FormState extends State<_Form> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.mail_outline,
            hintText: 'Correp',
            textEditingController: emailController,
            keyboardType: TextInputType.emailAddress,
            isPassword: false,
          ),
          CustomInput(
            icon: Icons.lock_outline,
            hintText: 'Contraseña',
            textEditingController: passwordController,
            keyboardType: TextInputType.emailAddress,
            isPassword: true,
          ),
          BlueButton(onPressed: () {
            print(emailController.text);
            print(passwordController.text);
          }),
        ],
      ),
    );
  }
}
