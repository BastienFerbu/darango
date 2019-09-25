part of darango;

class Document {
  String id;
  String key;
  String rev;
  dynamic data;
  Collection collection;

  Document(this.collection, {this.id});

  void add(Map<String, dynamic> data)async {
    String d = jsonEncode(data);
    Request request = collection.client.prepareRequest("/_api/document/" + collection.name, methode: "post");
    request.body = d;
    StreamedResponse response = await collection.client.send(request);
    print(await response.stream.bytesToString());
  }

  Future<Document> get(String id) async{
    Request request = collection.client.prepareRequest("/_api/document/" + id);
    StreamedResponse response = await collection.client.send(request);
    String doc_str = await response.stream.bytesToString();
    print(doc_str);
    Map<dynamic, dynamic> doc = jsonDecode(doc_str);
    this.id = doc.remove('_id');
    this.key = doc.remove('_key');
    this.rev = doc.remove('_rev');
    this.data = doc;
    return this;
  }

  void update(Map<String, dynamic> data) async{
    String d = jsonEncode(data);
    Request request = collection.client.prepareRequest("/_api/document/" + data['_id'], methode: "patch");
    request.body = d;
    StreamedResponse response = await collection.client.send(request);
    print(await response.stream.bytesToString());
  }

  void delete(){
    
  }
}