import 'dart:async';

import 'package:darango/darango.dart';
import 'darango_test.dart';

FutureOr<void> main(List<String> args) async {
  var id = '';
  Database database;
  database = Database(url);

  await database.connect(database_name, username, password);

  Collection? usersCollection;
  usersCollection = await database.collection('users');

  Document doc;
  doc = await usersCollection!.document(document_handle: id).get();
  print(doc.data);
  var user2 = {
    '_key': doc.key,
    '_id': doc.id,
    '_rev': doc.rev,
    'lastName': 'Toto',
    'FirstName': 'Titi',
    'email': 'toto@titi.com'
  };
  doc = await usersCollection.document().update(user2);
  print(doc.data);

  database.close();
}
