import 'package:bet_better/services/firebase_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showDialogPanelIos(
  BuildContext context,
  TextEditingController controller,
  String mode,
) {
  showCupertinoDialog(
    context: context,
    builder: (context) {
      return CupertinoAlertDialog(
        title: const Text('Enter amount'),
        content: CupertinoTextField(
          controller: controller,
          keyboardType: TextInputType.number,
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              controller.clear();
              Navigator.pop(context);
            },
            isDestructiveAction: true,
            child: const Text('Cancel'),
          ),
          CupertinoDialogAction(
            onPressed: () {
              if (controller.text == '' || controller.text == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please input a value.'),
                  ),
                );
              }
              // TODO: if users pastes, make sure that it is also a valid number
              int c = int.parse(controller.text);
              AuthService().updateUserInput(mode, c, false);
              controller.clear();
              Navigator.pop(context);
            },
            child: const Text('Submit'),
          )
        ],
      );
    },
  );
}

void showDialogPaneAndroid(
  BuildContext context,
  TextEditingController controller,
  String mode,
) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Enter amount'),
        content: TextField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
          controller: controller,
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            onPressed: () {
              controller.clear();
              Navigator.pop(context);
            },
            // isDestructiveAction: true,
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text == '' || controller.text == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please input a value.'),
                  ),
                );
              }
              // TODO: if users pastes, make sure that it is also a valid number
              int c = int.parse(controller.text);
              AuthService().updateUserInput(mode, c, false);
              controller.clear();
              Navigator.pop(context);
            },
            child: const Text('Submit'),
          )
        ],
      );
    },
  );
}
