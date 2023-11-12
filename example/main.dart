import 'dart:async';

import 'package:flutter/material.dart';
import 'package:darango/darango.dart';

late Database database;

late Collection usersCollection;

void initArangoDB() async {
  database = Database('http://10.0.2.2:8529');
  await database.connect('', '', '');
  usersCollection = (await database.collection('users'))!;
}

FutureOr<dynamic> getUser(String id) async {
  Document doc;
  doc = await usersCollection.document(document_handle: id).get();
  print(doc.data);
  return doc.data;
}

void main() async {
  initArangoDB();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    getUser('');

    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Welcome to Flutter'),
        ),
        body: Center(
          child: Text('Hello World'),
        ),
      ),
    );
  }
}
