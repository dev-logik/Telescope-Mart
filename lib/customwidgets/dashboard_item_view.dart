import 'package:flutter/material.dart';
import 'package:telescope_mart/models/dashboard_model.dart';

class DashboardItemView extends StatelessWidget {
  final DashboardModel model;
  final ValueSetter<String> onPress;
  const DashboardItemView({
    super.key,
    required this.model,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onPress(model.routeName),
      child: Card(
        child: Center(
          child: Column(
            mainAxisAlignment: .center,
            children: [
              Icon(model.icon, size: 50),
              const SizedBox(height: 10),
              Text(model.title, style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
        ),
      ),
    );
  }
}
