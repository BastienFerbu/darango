part of darango;

class Document {
  String id;
  String key;
  String rev;
  dynamic data;
  Collection collection;

  Document(this.collection, {this.id});

  Future<Document> add(Map<String, dynamic> data)async {
    String d = jsonEncode(data);
    Request request = collection.client.prepareRequest("/_api/document/" + collection.name, methode: "post");
    request.body = d;
    StreamedResponse response = await collection.client.send(request);
    String doc_str = await response.stream.bytesToString();
    Map<dynamic, dynamic> doc = jsonDecode(doc_str);
    this.id = doc.remove('_id');
    this.key = doc.remove('_key');
    this.rev = doc.remove('_rev');
    this.data = data;
    return this;
  }

  Future<Document> get(String id) async{
    Request request = collection.client.prepareRequest("/_api/document/" + id);
    StreamedResponse response = await collection.client.send(request);
    String doc_str = await response.stream.bytesToString();
    Map<dynamic, dynamic> doc = jsonDecode(doc_str);
    this.id = doc.remove('_id');
    this.key = doc.remove('_key');
    this.rev = doc.remove('_rev');
    this.data = doc;
    return this;
  }

  Future<Document> update(Map<String, dynamic> data) async{
    this.id = data.remove('_id');
    this.key = data.remove('_key');
    data.remove('_rev');
    this.data = data;
    String d = jsonEncode(data);
    Request request = collection.client.prepareRequest("/_api/document/" + this.id, methode: "patch");
    request.body = d;
    StreamedResponse response = await collection.client.send(request);
    String doc_str = await response.stream.bytesToString();
    Map<dynamic, dynamic> doc = jsonDecode(doc_str);
    this.rev = doc.remove('_rev');
    return this;
  }

  void delete(String id) async {
    Request request = collection.client.prepareRequest("/_api/document/" + id, methode: "delete");
    await collection.client.send(request);
  }
}