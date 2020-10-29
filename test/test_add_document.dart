import 'package:darango/darango.dart';
import 'darango_test.dart';

Future<void> main(List<String> args) async {
  Database database;
  database = Database(url);
  await database.connect(database_name, username, password);

  Collection usersCollection;
  usersCollection = await database.collection('users');

  if (usersCollection != null) {
    var user = {'lastName': 'Toto', 'FirstName': 'Titi'};
    Document doc;
    doc = await usersCollection.document().add(user);
    print(doc.data);
  }

  database.close();
}
