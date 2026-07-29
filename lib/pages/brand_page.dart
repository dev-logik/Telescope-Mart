import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:telescope_mart/providers/telescope_provider.dart';
import 'package:telescope_mart/utils/widget_functions.dart';

class BrandPage extends StatelessWidget {
  static const String routeName = "brand";
  const BrandPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("All Brands")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showSingleTextInputDialog(
            context: context,
            title: "Add Brand",
            positiveBtnText: "OK",
            negativeBtnText: "CLOSE",
            onSubmit: (name) {
              EasyLoading.show(status: "Please wait");
              Provider.of<TelescopeProvider>(
                context,
                listen: false,
              ).addBrand(name).then((value) {
                EasyLoading.dismiss();
                showMessage(context, "Brand Added");
              });
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Consumer<TelescopeProvider>(
        builder: (context, provider, child) => provider.brandList.isEmpty
            ? Center(child: Text("No Brand Found"))
            : ListView.builder(
                itemBuilder: (context, index) {
                  final brand = provider.brandList[index];
                  return ListTile(title: Text(brand.name));
                },
                itemCount: provider.brandList.length,
              ),
      ),
    );
  }
}
