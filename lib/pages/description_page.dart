import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:telescope_mart/providers/telescope_provider.dart';
import 'package:telescope_mart/utils/widget_functions.dart';

class DescriptionPage extends StatefulWidget {
  static const String routeName = "description";
  final String id;
  const DescriptionPage({super.key, required this.id});

  @override
  State<DescriptionPage> createState() => _DescriptionPageState();
}

class _DescriptionPageState extends State<DescriptionPage> {
  final _controller = TextEditingController();
  String? description;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    description = Provider.of<TelescopeProvider>(
      context,
      listen: false,
    ).getTelescopeById(widget.id).description;
    if (description != null) {
      _controller.text = description!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Description"),
        actions: [
          IconButton(onPressed: _saveDescription, icon: Icon(Icons.save)),
        ],
      ),
      body: Container(
        padding: .all(8),
        height: double.infinity,
        color: Colors.grey,
        child: TextField(
          controller: _controller,
          maxLines: 1000,
          autofocus: true,
          decoration: InputDecoration(border: OutlineInputBorder()),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _saveDescription() {
    if (_controller.text.isEmpty) {
      showMessage(context, "Field is empty");
      return;
    }

    EasyLoading.show(status: "Please wait");
    Provider.of<TelescopeProvider>(context, listen: false)
        .updateTelescopeField(widget.id, "description", _controller.text)
        .then((value) {
          if (context.mounted) {
            showMessage(context, "Description updated");
            EasyLoading.dismiss();
          }
        })
        .catchError((err) {
          if (context.mounted) {
            showMessage(context, "Error while updating description");
          }
          EasyLoading.dismiss();
        });
  }
}
