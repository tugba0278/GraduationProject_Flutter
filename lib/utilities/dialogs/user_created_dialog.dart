import 'package:bitirme_projesi/utilities/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<void> userCreatedDialog(BuildContext context, String text) {
  return showGenericDialog<void>(
    context: context,
    title: "Kayıt olundu.",
    content: text,
    optionsBuilder: () => {
      // an inline function that returns a map/dict
      "Tamam": null,
    },
  );
}
