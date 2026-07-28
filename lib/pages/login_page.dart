import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:telescope_mart/auth/auth_service.dart';
import 'package:telescope_mart/pages/dashboard_page.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = "/login";
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _errorMessage = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const .all(24.0),
            shrinkWrap: true,
            children: [
              TextFormField(
                keyboardType: .emailAddress,
                controller: _emailController,
                decoration: const InputDecoration(
                  filled: true,
                  prefixIcon: Icon(Icons.email),
                  labelText: "Email Address",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Provide a valid email address";
                  }
                  return null;
                },
              ),
              TextFormField(
                keyboardType: .visiblePassword,
                obscureText: true,
                controller: _passwordController,
                decoration: const InputDecoration(
                  filled: true,
                  prefixIcon: Icon(Icons.password),
                  labelText: "Password (at least 6 characters)",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Provide a valid password";
                  }
                  return null;
                },
              ),

              ElevatedButton(
                onPressed: _authenticate,
                child: Text('Login as Admin'),
              ),

              Text(
                _errorMessage,
                style: const TextStyle(fontSize: 18, color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _authenticate() async {
    if (_formKey.currentState!.validate()) {
      EasyLoading.show(status: "Please wait");
      final email = _emailController.text;
      final password = _passwordController.text;

      try {
        final isLoggedIn = await AuthService.loginAdmin(email, password);
        EasyLoading.dismiss();
        if (context.mounted && isLoggedIn) {
          context.goNamed(DashboardPage.routeName);
        }
      } on FirebaseAuthException catch (error) {
        EasyLoading.dismiss();
        setState(() {
          _errorMessage = error.message!;
        });
      }
    }
  }
}
