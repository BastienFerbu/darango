import 'package:darango/darango.dart';
import 'package:http/http.dart';
import 'dart:convert';

main(List<String> args) async {
  Database database = Database("http://127.0.0.1:8529");
  await database.connect("zaucard", "root", "24861793");

  await database.current();
  database.arangoClient.close();
}