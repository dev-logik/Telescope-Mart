import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:telescope_mart/customwidgets/image_holder_view.dart';
import 'package:telescope_mart/models/image_model.dart';
import 'package:telescope_mart/models/telescope.dart';
import 'package:telescope_mart/pages/description_page.dart';
import 'package:telescope_mart/providers/telescope_provider.dart';
import 'package:telescope_mart/utils/constants.dart';
import 'package:telescope_mart/utils/helper_functions.dart';
import 'package:telescope_mart/utils/widget_functions.dart';

class TelescopeDetailsPage extends StatefulWidget {
  static const String routeName = "telescopedetails";
  final String id;
  const TelescopeDetailsPage({super.key, required this.id});

  @override
  State<TelescopeDetailsPage> createState() => _TelescopeDetailsPageState();
}

class _TelescopeDetailsPageState extends State<TelescopeDetailsPage> {
  late TelescopeProvider provider;
  late Telescope telescope;

  @override
  void didChangeDependencies() {
    provider = Provider.of<TelescopeProvider>(context);
    telescope = provider.getTelescopeById(widget.id);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          telescope.model,
          style: const TextStyle(overflow: .ellipsis),
        ),
      ),
      body: ListView(
        children: [
          CachedNetworkImage(
            imageUrl: telescope.thumbnail.downloadUrl,
            width: double.infinity,
            height: 300,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) =>
                const Icon(Icons.error, size: 50),
          ),

          SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: 100,
            child: Card(
              child: ListView(
                scrollDirection: .horizontal,
                padding: .all(8),
                children: [
                  FloatingActionButton.small(
                    onPressed: () {
                      getImage(ImageSource.gallery);
                    },
                    tooltip: "Add adtitional images",
                    child: Icon(Icons.add),
                  ),
                  if (telescope.additionalImage.isEmpty)
                    Padding(
                      padding: .only(left: 16),
                      child: Center(
                        child: Text(
                          "Add other images",
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(color: Colors.grey),
                        ),
                      ),
                    ),

                  ...telescope.additionalImage.map(
                    (e) => ImageHolderView(
                      imageModel: e,
                      onPressed: () {
                        _showImageOnDialog(e);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          ElevatedButton(
            onPressed: () {
              telescope.description == null
                  ? context.goNamed(
                      DescriptionPage.routeName,
                      extra: telescope.id!,
                    )
                  : _showDescriptionDialogue();
            },
            child: Text(
              telescope.description == null
                  ? "Add Description"
                  : "Show description",
            ),
          ),

          ListTile(
            title: Text(telescope.brand.name),
            subtitle: Text(telescope.model),
          ),
          ListTile(
            title: Text(
              "Sale Price(with discount): $currencySymbol${priceAfterDiscount(telescope.price, telescope.discount).toStringAsFixed(0)}",
            ),
            subtitle: Text("Original Price: $currencySymbol${telescope.price}"),
            trailing: IconButton(
              onPressed: () {
                showSingleTextInputDialog(
                  context: context,
                  title: "Edit Price",
                  positiveBtnText: "OK",
                  negativeBtnText: "CANCEL",
                  onSubmit: (value) {
                    EasyLoading.show(status: "Please wait");
                    provider
                        .updateTelescopeField(
                          telescope.id!,
                          'price',
                          num.parse(value),
                        )
                        .then((value) {
                          if (context.mounted) {
                            showMessage(context, "Price updated");
                            EasyLoading.dismiss();
                          }
                        })
                        .catchError((err) {
                          if (context.mounted) {
                            showMessage(context, "Cannot update price");
                            EasyLoading.dismiss();
                          }
                        });
                  },
                );
              },
              icon: Icon(Icons.edit),
            ),
          ),
          ListTile(
            title: Text("Discount(0-100%): ${telescope.discount}"),
            trailing: IconButton(
              onPressed: () {
                showSingleTextInputDialog(
                  context: context,
                  title: "Edit Discount",
                  positiveBtnText: "OK",
                  negativeBtnText: "CANCEL",
                  onSubmit: (value) {
                    EasyLoading.show(status: "Please wait");
                    provider
                        .updateTelescopeField(
                          telescope.id!,
                          'discount',
                          num.parse(value),
                        )
                        .then((value) {
                          if (context.mounted) {
                            showMessage(context, "Discount updated");
                            EasyLoading.dismiss();
                          }
                        })
                        .catchError((err) {
                          if (context.mounted) {
                            showMessage(context, "Cannot update discount");
                            EasyLoading.dismiss();
                          }
                        });
                  },
                );
              },
              icon: Icon(Icons.edit),
            ),
          ),
          ListTile(
            title: Text("Stock: ${telescope.stock}"),
            trailing: IconButton(
              onPressed: () {
                showSingleTextInputDialog(
                  context: context,
                  title: "Edit Stock",
                  positiveBtnText: "OK",
                  negativeBtnText: "CANCEL",
                  onSubmit: (value) {
                    EasyLoading.show(status: "Please wait");
                    provider
                        .updateTelescopeField(
                          telescope.id!,
                          'stock',
                          num.parse(value),
                        )
                        .then((value) {
                          if (context.mounted) {
                            showMessage(context, "Stock updated");
                            EasyLoading.dismiss();
                          }
                        })
                        .catchError((err) {
                          if (context.mounted) {
                            showMessage(context, "Cannot update stock");
                            EasyLoading.dismiss();
                          }
                        });
                  },
                );
              },
              icon: Icon(Icons.edit),
            ),
          ),
        ],
      ),
    );
  }

  void getImage(ImageSource source) async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: source, imageQuality: 50);
    if (file != null) {
      EasyLoading.show(status: "Please wait");
      final newImage = await provider.uploadImage(file.path);
      telescope.additionalImage.add(newImage);
      provider
          .updateTelescopeField(
            telescope.id!,
            "additionalImage",
            toImageMapList(telescope.additionalImage),
          )
          .then((value) {
            if (context.mounted) {
              showMessage(context, "Added");
            }
            EasyLoading.dismiss();
            setState(() {});
          })
          .catchError((err) {
            EasyLoading.dismiss();
            if (context.mounted) {
              showMessage(context, "Failed to add");
            }
          });
    }
  }

  void _showImageOnDialog(ImageModel image) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: CachedNetworkImage(
          imageUrl: image.downloadUrl,
          fit: .contain,
          height: MediaQuery.sizeOf(context).height / 2,
          placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) =>
              Center(child: Icon(Icons.error)),
        ),

        actions: [
          IconButton(
            onPressed: () async {
              context.pop(context);
              EasyLoading.show(status: "Please wait");
              try {
                await provider.deleteImage(telescope.id!, image);
                telescope.additionalImage.remove(image);
                await provider.updateTelescopeField(
                  telescope.id!,
                  "additionalImage",
                  toImageMapList(telescope.additionalImage),
                );
                EasyLoading.dismiss();
                setState(() {});
                EasyLoading.dismiss();
              } catch (err) {
                EasyLoading.dismiss();
              }
            },
            icon: const Icon(Icons.delete),
          ),
          IconButton(
            onPressed: () {
              context.pop(context);
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }

  void _showDescriptionDialogue() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(telescope.model),
        content: SingleChildScrollView(child: Text(telescope.description!)),
        actions: [
          TextButton(
            onPressed: () {
              context.pop();
              context.goNamed(DescriptionPage.routeName, extra: telescope.id);
            },
            child: Text("EDIT"),
          ),
          TextButton(
            onPressed: () {
              context.pop();
            },
            child: Text("CLOSE"),
          ),
        ],
      ),
    );
  }
}
