import 'package:darango/darango.dart';
import 'darango_test.dart';

main(List<String> args) async {
  String id = "";
  Database database = Database(url);

  await database.connect(database_name, username, password);
  
  Collection usersCollection = await database.collection("users");

  Document doc = await usersCollection.document().get(id);
  print(doc.data);
  Map<String, dynamic> user2 = {"_key":doc.key,"_id":doc.id,"_rev":doc.rev,"lastName":"Toto","FirstName":"Titi", "email": "toto@titi.com"};
  doc = await usersCollection.document().update(user2);
  print(doc.data);

  database.close();
}