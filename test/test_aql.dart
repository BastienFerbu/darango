import 'dart:async';

import 'package:darango/darango.dart';
import 'darango_test.dart';

FutureOr<void> main(List<String> args) async {
  Database database;
  database = Database(url);

  await database.connect(database_name, username, password);

  Aql aql;
  aql = database.aql();
  var query = '''
    FOR c IN users
    RETURN c
  ''';

  dynamic result = await aql.run(query);
  print(result['result']);

  database.close();
}
