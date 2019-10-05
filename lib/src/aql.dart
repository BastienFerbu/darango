part of darango;

class Aql{
  ArangoClient client;
  Aql(this.client);

  Future<dynamic> run(String query, {bool count=true, int batchSize = 2}) async{
    Request request = client.prepareRequest("/_api/cursor", methode: "post");
    request.body = jsonEncode({ "query" : query, "count" : count, "batchSize" : batchSize });
    StreamedResponse response = await client.send(request);
    String doc_str = await response.stream.bytesToString();
    Map<dynamic, dynamic> doc = jsonDecode(doc_str);
    if(doc["error"]){
      print(doc["errorMessage"]);
      return null;
    }
    else{
      return doc;
    }
  }

  Future<dynamic> nextBatch(String id) async{
    Request request = client.prepareRequest("/_api/cursor/$id", methode: "get");
    StreamedResponse response = await client.send(request);
    String doc_str = await response.stream.bytesToString();
    Map<dynamic, dynamic> doc = jsonDecode(doc_str);
    if(doc["error"]){
      print(doc["errorMessage"]);
      return null;
    }
    else{
      return doc;
    }
  }
}