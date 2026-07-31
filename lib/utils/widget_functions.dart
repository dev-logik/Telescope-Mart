import 'package:flutter/material.dart';

void showSingleTextInputDialog({
  required BuildContext context,
  required String title,
  required String positiveBtnText,
  required String negativeBtnText,
  required Function(String) onSubmit,
}) {
  final controller = TextEditingController();
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Padding(
        padding: .all(12),
        child: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(labelText: title),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(negativeBtnText),
        ),
        TextButton(
          onPressed: () {
            if (controller.text.isEmpty) return;
            onSubmit(controller.text);
            Navigator.pop(context);
          },
          child: Text(positiveBtnText),
        ),
      ],
    ),
  );
}

void showMessage(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}
