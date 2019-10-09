part of darango;

class Document {
  String id;
  String key;
  String rev;
  dynamic data;
  Collection collection;

  Document(this.collection, {this.id});

  Map<String, dynamic> toMap({var separated = false}) {
    Map<String, dynamic> doc;
    if(!separated){
      doc = this.data;
      doc['_id'] = this.id;
      doc['_key'] = this.key;
      doc['_rev'] = this.rev;
    }
    else{
      doc = {"_id" : this.id, "_key": this.key, "_rev":this.rev, "data":this.data};
    }
    return doc;
  }

  String toString({var separated = false}) => this.toMap(separated: separated).toString();

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

  bool isId(String s){
    return s.contains('/');
  }

  Future<Document> get(String s) async{
    String url = isId(s) ? "/_api/document/$s" : "/_api/document/${collection.name}/$s";
    Request request = collection.client.prepareRequest(url);
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

  void delete(String s) async {
    String url = isId(s) ? "/_api/document/$s" : "/_api/document/${collection.name}/$s";
    Request request = collection.client.prepareRequest(url, methode: "delete");
    await collection.client.send(request);
  }
}