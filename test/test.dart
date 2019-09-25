import 'package:darango/darango.dart';
import 'package:http/http.dart';
import 'dart:convert';

main(List<String> args) async {
  Database database = Database("http://127.0.0.1:8529");

  await database.connect("zaucard", "root", "24861793");
  
  Collection usersCollection = await database.collection("users");

  //Map<String, dynamic> user = {"lastName":"Ferbu", "FirstName":"Bastien"};
  //usersCollection.document().add(user);
  usersCollection.document().get("users/87352");
  //Map<String, dynamic> user = {"_key":"87352","_id":"users/87352","_rev":"_ZUlhAXu---","lastName":"Ferbu","FirstName":"Bastien", "email": "bastien.ferbu@gmail.com"};
  //usersCollection.document().update(user);

  database.close();
}