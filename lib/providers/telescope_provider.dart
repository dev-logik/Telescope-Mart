import 'package:flutter/material.dart';
import 'package:telescope_mart/db/db_helper.dart';
import 'package:telescope_mart/models/brand.dart';

class TelescopeProvider with ChangeNotifier {
  List<Brand> brandList = [];
  Future<void> addBrand(String name) async {
    final brand = Brand(name: name);
    return DbHelper.addBrand(brand);
  }

  getAllBrand() {
    DbHelper.getAllBrands().listen((snapshot) {
      brandList = List.generate(
        snapshot.docs.length,
        (index) => Brand.fromMap(snapshot.docs[index].data()),
      );
      notifyListeners();
    });
  }
}
