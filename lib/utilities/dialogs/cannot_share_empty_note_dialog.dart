import 'package:bitirme_projesi/utilities/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showCannoShareEmptyNoteDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: "Sharing",
    content: "You cannot share an empty note!",
    // option builder return a [Map] with only one key-value pair
    optionsBuilder: () => {
      "OK": null,
    },
  );
}
