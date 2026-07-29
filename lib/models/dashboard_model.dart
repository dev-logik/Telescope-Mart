import 'package:flutter/material.dart';
import 'package:telescope_mart/pages/add_telescope_page.dart';
import 'package:telescope_mart/pages/brand_page.dart';
import 'package:telescope_mart/pages/view_telescope_page.dart';

class DashboardModel {
  final String routeName;
  final IconData icon;
  final String title;

  DashboardModel({
    required this.routeName,
    required this.icon,
    required this.title,
  });
}

List<DashboardModel> dashboardModels = [
  DashboardModel(
    title: "Add Telescope",
    icon: Icons.add,
    routeName: AddTelescopePage.routeName,
  ),
  DashboardModel(
    title: "View Telescopes",
    icon: Icons.inventory,
    routeName: ViewTelescopePage.routeName,
  ),
  DashboardModel(
    title: "Brands",
    icon: Icons.category,
    routeName: BrandPage.routeName,
  ),
];
