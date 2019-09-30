part of darango;

class Graph {
  String name;
  String id;
  String key;
  String rev;
  ArangoClient client;
  Graph(this.name, this.client);
  
  Future<Graph> get(String name) async{
    Request request = client.prepareRequest("/_api/gharial/"+this.name);
    StreamedResponse response = await client.send(request);
    String doc_str = await response.stream.bytesToString();
    Map<dynamic, dynamic> doc = jsonDecode(doc_str);
    this.id = doc.remove('_id');
    this.key = doc.remove('_key');
    this.rev = doc.remove('_rev');
    this.name = doc.remove('name');
    return this;
  }
}