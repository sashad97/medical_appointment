import 'package:flutter/material.dart';

class MessageDialog extends StatelessWidget {
  final String? title;
  final String? description;
  final String? cancelTitle;
  final String? buttonTitle;
  final void Function()? onPressed;
  MessageDialog(
      {this.buttonTitle,
      this.cancelTitle,
      this.description,
      this.title,
      required this.onPressed});
  @override
  Widget build(BuildContext context) {
    var isConfirmationDialog = cancelTitle!.isNotEmpty;
    return AlertDialog(
      title: Text(title!),
      content: Text(description!),
      actions: <Widget>[
        if (isConfirmationDialog)
          TextButton(
            child: Text(cancelTitle!),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        TextButton(
          child: Text(buttonTitle!),
          onPressed: onPressed,
        ),
      ],
    );
  }
}
