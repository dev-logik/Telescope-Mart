import 'package:flutter/material.dart';

class RadioOptions extends StatefulWidget {
  final String label;
  final ValueSetter onItemSelected;
  final List<String> items;
  final String groupValue;
  const RadioOptions({
    super.key,
    required this.label,
    required this.onItemSelected,
    required this.items,
    required this.groupValue,
  });

  @override
  State<RadioOptions> createState() => _RadioOptionsState();
}

class _RadioOptionsState extends State<RadioOptions> {
  late String groupValue;
  @override
  void initState() {
    groupValue = widget.groupValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: RadioGroup(
        groupValue: groupValue,
        onChanged: (value) {
          setState(() {
            groupValue = value!;
          });

          widget.onItemSelected(value);
        },
        child: Column(
          children: [
            Text(widget.label),
            for (int i = 0; i < widget.items.length; i++)
              Row(
                spacing: 8,
                children: [
                  Radio(value: widget.items[i]),
                  Text(widget.items[i]),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
