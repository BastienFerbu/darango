import 'package:darango/darango.dart';
import 'darango_test.dart';

main(List<String> args) async {
  Database database = Database(url);

  await database.connect(database_name, username, password);
  
  Transaction transaction = await database.transaction();
  Map<String, dynamic> collections = { 
    "read" : "users" 
  };
  String action = "function () { var db = require('@arangodb').db; return db.users.count(); }";

  dynamic res = await transaction.execute(collections, action);
  print(res);
  database.close();
}