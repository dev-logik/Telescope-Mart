import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:telescope_mart/auth/auth_service.dart';
import 'package:telescope_mart/firebase_options.dart';
import 'package:telescope_mart/pages/dashboard_page.dart';
import 'package:telescope_mart/pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Telescope Mart',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
    );
  }

  final _router = GoRouter(
    initialLocation: DashboardPage.routeName,
    debugLogDiagnostics: true,
    redirect: _redirect,
    routes: [
      GoRoute(
        path: DashboardPage.routeName,
        name: DashboardPage.routeName,
        builder: (context, state) => const DashboardPage(),
      ),
      GoRoute(
        path: LoginPage.routeName,
        name: LoginPage.routeName,
        builder: (context, state) => const LoginPage(),
      ),
    ],
  );

  static FutureOr<String?> _redirect(BuildContext _, GoRouterState state) {
    if (AuthService.currentUser == null) {
      return LoginPage.routeName;
    }
    return null;
  }
}
