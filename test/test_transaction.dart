import 'dart:async';

import 'package:darango/darango.dart';
import 'darango_test.dart';

FutureOr<void> main(List<String> args) async {
  Database database;
  database = Database(url);

  await database.connect(database_name, username, password);

  Transaction transaction;
  transaction = await database.transaction();
  var collections = {'read': 'users'};
  var action =
      "function () { var db = require('@arangodb').db; return db.users.count(); }";

  dynamic res = await transaction.executeTransaction(collections, action);
  print(res);
  database.close();
}
