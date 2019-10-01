import 'package:darango/darango.dart';
import 'package:http/http.dart';
import 'dart:convert';

main(List<String> args) async {
  Database database = Database("http://127.0.0.1:8529");

  await database.connect("zaucard", "root", "24861793");
  
  Collection usersCollection = await database.collection("user");

  Map<String, dynamic> user = {"lastName":"Toto", "FirstName":"Titi"};
  Document doc = await usersCollection.document().add(user);
  print(doc.data);
  /* doc = await usersCollection.document().get(doc.id);
  print(doc.data);
  Map<String, dynamic> user2 = {"_key":doc.key,"_id":doc.id,"_rev":doc.rev,"lastName":"Toto","FirstName":"Titi", "email": "toto@gmail.com"};
  doc = await usersCollection.document().update(user2);
  print(doc.data);
  await usersCollection.document().delete(doc.id); */

  database.close();
}