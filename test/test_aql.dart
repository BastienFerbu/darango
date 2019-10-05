import 'package:darango/darango.dart';
import 'darango_test.dart';

main(List<String> args) async {
  Database database = Database(url);

  await database.connect(database_name, username, password);
  
  Aql aql = database.aql();
  String query = """
    FOR c IN users
    RETURN c
  """;

  dynamic result = await aql.run(query);
  print(result["result"]);

  database.close();
}