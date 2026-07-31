import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:telescope_mart/auth/auth_service.dart';
import 'package:telescope_mart/firebase_options.dart';
import 'package:telescope_mart/pages/add_telescope_page.dart';
import 'package:telescope_mart/pages/brand_page.dart';
import 'package:telescope_mart/pages/dashboard_page.dart';
import 'package:telescope_mart/pages/description_page.dart';
import 'package:telescope_mart/pages/login_page.dart';
import 'package:telescope_mart/pages/telescope_details_page.dart';
import 'package:telescope_mart/pages/view_telescope_page.dart';
import 'package:telescope_mart/providers/telescope_provider.dart';

final supabase = Supabase.instance.client;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Supabase.initialize(
    url: "https://bxeoxtsmgkfikxhpzltt.supabase.co",
    publishableKey: "sb_publishable_nUvsbKwIADam-84om6aLyQ_Qj6zM9Ki",
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TelescopeProvider()),
      ],
      child: MyApp(),
    ),
  );
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
        routes: [
          GoRoute(
            path: ViewTelescopePage.routeName,
            name: ViewTelescopePage.routeName,
            builder: (context, state) => ViewTelescopePage(),
            routes: [
              GoRoute(
                path: TelescopeDetailsPage.routeName,
                name: TelescopeDetailsPage.routeName,
                builder: (context, state) =>
                    TelescopeDetailsPage(id: state.extra! as String),
                routes: [
                  GoRoute(
                    path: DescriptionPage.routeName,
                    name: DescriptionPage.routeName,
                    builder: (context, state) =>
                        DescriptionPage(id: state.extra! as String),
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: AddTelescopePage.routeName,
            name: AddTelescopePage.routeName,
            builder: (context, state) => AddTelescopePage(),
          ),
          GoRoute(
            path: BrandPage.routeName,
            name: BrandPage.routeName,
            builder: (context, state) => BrandPage(),
          ),
        ],
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
