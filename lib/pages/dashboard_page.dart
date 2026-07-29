import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:telescope_mart/auth/auth_service.dart';
import 'package:telescope_mart/customwidgets/dashboard_item_view.dart';
import 'package:telescope_mart/models/dashboard_model.dart';
import 'package:telescope_mart/pages/login_page.dart';
import 'package:telescope_mart/providers/telescope_provider.dart';

class DashboardPage extends StatefulWidget {
  static const String routeName = '/';
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void didChangeDependencies() {
    Provider.of<TelescopeProvider>(context, listen: false).getAllBrand();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
        actions: [IconButton(onPressed: _onLogOut, icon: Icon(Icons.logout))],
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: dashboardModels.length,
        itemBuilder: (context, index) {
          final model = dashboardModels[index];
          return DashboardItemView(
            model: model,
            onPress: (value) {
              context.goNamed(model.routeName);
            },
          );
        },
      ),
    );
  }

  void _onLogOut() {
    AuthService.logout().then((value) {
      return context.goNamed(LoginPage.routeName);
    });
  }
}
