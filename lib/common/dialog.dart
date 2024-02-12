
import 'package:flutter/material.dart';
// Create a reusable showDialog function that takes in a title, content, and two action buttons.
// The first button should cancel the dialog and the second button should trigger a function.
Future<void> showDialogReuseable({
  required BuildContext context,
  required String title,
  required Widget? content,
  required String yesText,
  required VoidCallback yesFunc,
}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: content,
        actions: <Widget>[
          TextButton(
            child: Text("Cancel"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text(yesText),
            onPressed: yesFunc,
          ),
        ],
      );
    },
  );
}

void loadingDialog(context){
 showDialog(barrierDismissible: false,context: context, builder: (context) => Center(child: SizedBox(width:55,height:55,child: CircularProgressIndicator())),);
}
