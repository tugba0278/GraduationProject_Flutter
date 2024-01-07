import 'package:bitirme_projesi/utilities/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<bool> showLogOutDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: "Çıkış",
    content: "Çıkış yapmak istiyor musunuz?",
    optionsBuilder: () => {
      "İptal": false,
      "Çıkış Yap": true,
    },
  ).then(
    (value) => value ?? false,
  );
}
