import 'package:darango/darango.dart';
import 'darango_test.dart';

main(List<String> args) async {
  String id = "users/139196";
  Database database = Database(url);

  await database.connect(database_name, username, password);
  
  Collection usersCollection = await database.collection("users");

  Document doc = await usersCollection.document(document_handle: id).get();
  print(doc.data);
  await usersCollection.document(document_handle: doc.id).delete(); 

  database.close();
}