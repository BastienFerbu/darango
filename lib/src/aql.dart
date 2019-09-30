part of darango;

class Aql{
  ArangoClient client;
  Aql(this.client);

  query(String query) async{
    Request request = client.prepareRequest("/_api/query");
    request.body = query;
    StreamedResponse response = await client.send(request);
    String doc_str = await response.stream.bytesToString();
    Map<dynamic, dynamic> doc = jsonDecode(doc_str);
    if(doc["error"]){
      print(doc["errorMessage"]);
      return null;
    }
    else{
      return doc['ast'];
    }
  }
}