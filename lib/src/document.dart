part of darango;

class Document {
  String id;
  String key;
  String rev;
  dynamic data;
  Collection collection;

  Document({this.collection, this.key, this.id});

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
    Map<dynamic, dynamic> doc = await collection.client.exec(request);
    this.id = doc.remove('_id');
    this.key = doc.remove('_key');
    this.rev = doc.remove('_rev');
    this.data = data;
    return this;
  }

  bool isId(String s){
    return s.contains('/');
  }

  Future<Document> get() async{
    //String url = isId(s) ? "/_api/document/$s" : "/_api/document/${collection.name}/$s";
    Request request = collection.client.prepareRequest("/_api/document/${this.id}");
    StreamedResponse response = await collection.client.send(request);
    String doc_str = await response.stream.bytesToString();
    Map<dynamic, dynamic> doc = jsonDecode(doc_str);
    //this.id = doc.remove('_id');
    //this.key = doc.remove('_key');
    this.rev = doc.remove('_rev');
    this.data = doc;
    return this;
  }

  Future<Document> update(Map<String, dynamic> data, {String col}) async{
    data.remove('_id');
    data.remove('_key');
    data.remove('_rev');
    String d = jsonEncode(data);
    Request request;
    if(col == null)
      request = collection.client.prepareRequest("/_api/document/" + this.id, methode: "patch");
    else
      request = collection.client.prepareRequest("/_api/document/" + col, methode: "patch");
    request.body = d;
    Map<dynamic, dynamic> doc = await collection.client.exec(request);
    this.data = data;
    //this.rev = doc.remove('_rev');
    return this;
  }

  void delete() async {
    Request request = collection.client.prepareRequest("/_api/document/${this.id}", methode: "delete");
    await collection.client.send(request);
  }

  Future<Map<String, dynamic>> head() async{
    Map<String, dynamic> res;
    try {
      Request request = collection.client.prepareRequest("/_api/document/${this.id}", methode: "head");
      res = await collection.client.exec(request);
    } catch (e) {
      print(e);
    }
    return res;
  }

  Future<Map<String, dynamic>> allDocuments(String col,{String type}) async{
    Map<String, dynamic> res;
    try {
      Request request = collection.client.prepareRequest("/_api/simple/all-keys", methode: "put");
      request.body = type == null? '{"collection": $col}':'{"collection": $col, "type": $type}';
      res = await collection.client.exec(request);
    } catch (e) {
      print(e);
    }
    return res;
  }

  Future<Document> replace(Map<String, dynamic> data,{String col}) async{
    data.remove('_id');
    data.remove('_key');
    data.remove('_rev');
    String d = jsonEncode(data);
    Request request;
    if(col == null)
      request = collection.client.prepareRequest("/_api/document/" + this.id, methode: "put");
    else
      request = collection.client.prepareRequest("/_api/document/" + col, methode: "put");
    request.body = d;
    Map<dynamic, dynamic> doc = await collection.client.exec(request);
    this.data = data;
    //this.rev = doc.remove('_rev');
    return this;
  }

}