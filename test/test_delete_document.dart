import 'dart:async';

import 'package:darango/darango.dart';
import 'darango_test.dart';

FutureOr<void> main(List<String> args) async {
  var id = 'users/139196';
  Database database;
  database = Database(url);

  await database.connect(database_name, username, password);

  Collection? usersCollection;
  usersCollection = await database.collection('users');

  Document doc;
  doc = await usersCollection!.document(document_handle: id).get();
  print(doc.data);
  await usersCollection.document(document_handle: doc.id).delete();

  database.close();
}
