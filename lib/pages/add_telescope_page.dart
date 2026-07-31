import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:telescope_mart/customwidgets/radio_options.dart';
import 'package:telescope_mart/models/brand.dart';
import 'package:telescope_mart/models/telescope.dart';
import 'package:telescope_mart/providers/telescope_provider.dart';
import 'package:telescope_mart/utils/constants.dart';
import 'package:telescope_mart/utils/widget_functions.dart';

class AddTelescopePage extends StatefulWidget {
  static const String routeName = "addtelescope";

  const AddTelescopePage({super.key});

  @override
  State<AddTelescopePage> createState() => _AddTelescopePageState();
}

class _AddTelescopePageState extends State<AddTelescopePage> {
  late final TextEditingController _modelController;
  late final TextEditingController _dimensionController;
  late final TextEditingController _weightController;
  late final TextEditingController _lensDiameterController;
  late final TextEditingController _priceController;
  late final TextEditingController _stockController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _modelController = TextEditingController();
    _dimensionController = TextEditingController();
    _weightController = TextEditingController();
    _lensDiameterController = TextEditingController();
    _priceController = TextEditingController();
    _stockController = TextEditingController();
  }

  Brand? brand;
  String? imageLocalPath;
  DateTime? dateTime;
  String mountDescription = TelescopeUtils.mountList.first;
  String focusType = TelescopeUtils.focusList.first;
  String telescopeType = TelescopeUtils.typeList.first;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Telescope"),
        actions: [
          IconButton(onPressed: _saveTelescope, icon: Icon(Icons.save)),
        ],
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: .all(16),
            children: [
              Card(
                child: Column(
                  spacing: 10,
                  children: [
                    imageLocalPath == null
                        ? const Icon(Icons.image, size: 100)
                        : Image.file(
                            File(imageLocalPath!),
                            width: 100,
                            height: 100,
                            fit: .cover,
                          ),
                    const Text(
                      "Select Telescope Image\nfrom",
                      textAlign: .center,
                    ),
                    Row(
                      mainAxisAlignment: .center,
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            getImage(ImageSource.camera);
                          },
                          label: Text("Camera"),
                          icon: Icon(Icons.camera),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            getImage(ImageSource.gallery);
                          },
                          label: Text("Gallery"),
                          icon: Icon(Icons.browse_gallery),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Card(
                child: Padding(
                  padding: .all(8),
                  child: Consumer<TelescopeProvider>(
                    builder: (context, provider, child) {
                      return DropdownButtonFormField<Brand>(
                        decoration: InputDecoration(border: .none),
                        hint: const Text("Select Brand"),
                        isExpanded: true,
                        initialValue: brand,
                        validator: (value) {
                          if (value == null) {
                            return "Please select a brand";
                          }
                          return null;
                        },
                        items: provider.brandList
                            .map(
                              (item) => DropdownMenuItem<Brand>(
                                value: item,
                                child: Text(item.name),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          brand = value;
                        },
                      );
                    },
                  ),
                ),
              ),

              RadioOptions(
                label: "Select Telescope Type",
                onItemSelected: (value) {
                  telescopeType = value;
                },
                items: TelescopeUtils.typeList,
                groupValue: telescopeType,
              ),
              RadioOptions(
                label: "Select Mount Type",
                onItemSelected: (value) {
                  mountDescription = value;
                },
                items: TelescopeUtils.mountList,
                groupValue: mountDescription,
              ),
              RadioOptions(
                label: "Select Focus Type",
                onItemSelected: (value) {
                  focusType = value;
                },
                items: TelescopeUtils.focusList,
                groupValue: focusType,
              ),
              Padding(
                padding: .all(4),
                child: TextFormField(
                  controller: _modelController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    filled: true,
                    labelText: "Model",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "This field must not be empty";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: .all(4),
                child: TextFormField(
                  controller: _dimensionController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    filled: true,
                    labelText: "Dimension",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "This field must not be empty";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: .all(4),
                child: TextFormField(
                  keyboardType: .number,

                  controller: _weightController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    filled: true,
                    labelText: "Weight(lb)",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "This field must not be empty";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: .all(4),
                child: TextFormField(
                  controller: _lensDiameterController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    filled: true,
                    labelText: "Lens Diameter",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "This field must not be empty";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: .all(4),
                child: TextFormField(
                  keyboardType: .number,
                  controller: _priceController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    filled: true,
                    labelText: "Price",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "This field must not be empty";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: .all(4),
                child: TextFormField(
                  keyboardType: .number,

                  controller: _stockController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    filled: true,
                    labelText: "Stock",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "This field must not be empty";
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _modelController.dispose();
    _dimensionController.dispose();
    _lensDiameterController.dispose();
    _weightController.dispose();
    _stockController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _saveTelescope() async {
    if (imageLocalPath == null) {
      showMessage(context, "Please select a telescope image");
      return;
    }
    if (_formKey.currentState!.validate()) {
      EasyLoading.show(status: "Please wait");
      try {
        final imageModel = await Provider.of<TelescopeProvider>(
          context,
          listen: false,
        ).uploadImage(imageLocalPath!);

        final telescope = Telescope(
          model: _modelController.text,
          brand: brand!,
          type: telescopeType,
          dimension: _dimensionController.text,
          weightInPound: num.parse(_weightController.text),
          focusType: focusType,
          lensDiameterInMM: num.parse(_lensDiameterController.text),
          mountDescription: mountDescription,
          stock: num.parse(_stockController.text),
          price: num.parse(_priceController.text),
          thumbnail: imageModel,
          additionalImage: [],
        );

        if (context.mounted) {
          await Provider.of<TelescopeProvider>(
            context,
            listen: false,
          ).addTelescope(telescope);
          EasyLoading.dismiss();
          showMessage(context, "Saved");
          _resetFields();
        }
      } catch (error) {
        EasyLoading.dismiss();
        log(error.toString(), name: "In add telescope");
      }
    }
  }

  void _resetFields() {
    setState(() {
      _dimensionController.clear();
      _lensDiameterController.clear();
      _modelController.clear();
      _priceController.clear();
      _stockController.clear();
      _weightController.clear();
      brand = null;
      imageLocalPath = null;
      mountDescription = TelescopeUtils.mountList.first;
      mountDescription = TelescopeUtils.typeList.first;
      focusType = TelescopeUtils.focusList.first;
    });
  }

  void getImage(ImageSource source) async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: source, imageQuality: 50);
    if (file != null) {
      setState(() {
        imageLocalPath = file.path;
      });
    }
  }
}
