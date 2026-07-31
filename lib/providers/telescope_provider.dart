import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:telescope_mart/db/db_helper.dart';
import 'package:telescope_mart/main.dart';
import 'package:telescope_mart/models/brand.dart';
import 'package:telescope_mart/models/image_model.dart';
import 'package:telescope_mart/models/telescope.dart';
import 'package:telescope_mart/utils/constants.dart';

class TelescopeProvider with ChangeNotifier {
  List<Brand> brandList = [];
  List<Telescope> telescopeList = [];
  Future<void> addBrand(String name) async {
    final brand = Brand(name: name);
    return DbHelper.addBrand(brand);
  }

  void getAllBrand() {
    DbHelper.getAllBrands().listen((snapshot) {
      brandList = List.generate(
        snapshot.docs.length,
        (index) => Brand.fromJson(snapshot.docs[index].data()),
      );
      notifyListeners();
    });
  }

  void getAllTelescopes() {
    DbHelper.getAllTelescopes().listen((snapshot) {
      telescopeList = List.generate(
        snapshot.docs.length,
        (index) => Telescope.fromJson(snapshot.docs[index].data()),
      );
      notifyListeners();
    });
  }

  Telescope getTelescopeById(String id) =>
      telescopeList.firstWhere((telescope) => telescope.id == id);

  Future<void> addTelescope(Telescope telescope) {
    return DbHelper.addTelescope(telescope);
  }

  Future<void> updateTelescopeField(
    String id,
    String field,
    dynamic value,
  ) async {
    await DbHelper.updateTelescopeField(id, {field: value});
  }

  Future<ImageModel> uploadImage(String imageLocalPath) async {
    final String name = "image_${DateTime.now().millisecondsSinceEpoch}.jpg";

    final file = File(imageLocalPath);

    try {
      log("Before upload", name: "In Upload image");
      final filePath = await supabase.storage
          .from(telescopeImageDirectory)
          .upload(
            name,
            file,
            fileOptions: FileOptions(cacheControl: '3600', upsert: false),
          );

      var url = supabase.storage
          .from(telescopeImageDirectory)
          .getPublicUrl(filePath);
      url = url.replaceFirst("/$telescopeImageDirectory", "");
      log("After upload: $url", name: "In Upload image");
      return ImageModel(
        imageName: name,
        directoryName: telescopeImageDirectory,
        downloadUrl: url,
      );
    } catch (error) {
      print("Error uploading file: $error");
      rethrow;
    }
  }

  Future<void> deleteImage(String id, ImageModel image) async {
    final path = "$telescopeImageDirectory/${image.imageName}";
    await supabase.storage.from(telescopeImageDirectory).remove([path]);
    log("Path: $path");
  }
}
