import 'package:flutter/foundation.dart';

const String collectionBrand = "Brands";
const String brandFieldId = "id";
const String brandFieldName = "name";

class Brand {
  String? id;
  String name;
  Brand({this.id, required this.name});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{brandFieldId: id, brandFieldName: name};
  }

  factory Brand.fromMap(Map<String, dynamic> json) =>
      Brand(name: json[brandFieldName], id: json[brandFieldId]);
}
