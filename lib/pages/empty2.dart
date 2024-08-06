import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Empty2Page extends StatefulWidget {
  const Empty2Page({super.key});

  @override
  _Empty2PageState createState() => _Empty2PageState();
}

class _Empty2PageState extends State<Empty2Page> {
  CollectionReference colRef = FirebaseFirestore.instance.collection("events");
  DocumentReference docRef =
      FirebaseFirestore.instance.collection("events").doc("empty");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("merhaba"),
      ),
      body: ElevatedButton(
        onPressed: () async {
          var response = await colRef.get();
          var list = response.docs;
          print(list[2].data());
          //var docSnp = queryList[1].data();
          var docSnp = await docRef.get();
          print(docSnp.data());
        },
        child: Text("get data"),
        style: const ButtonStyle(),
      ),
    );
  }
}
