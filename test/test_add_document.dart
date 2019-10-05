import 'package:darango/darango.dart';
import 'darango_test.dart';

main(List<String> args) async {
  Database database = Database(url);

  await database.connect(database_name, username, password);
  
  Collection usersCollection = await database.collection("users");

  if(usersCollection != null){
    Map<String, dynamic> user = {"lastName":"Toto", "FirstName":"Titi"};
    Document doc = await usersCollection.document().add(user);
    print(doc.data);
  }

  database.close();
}