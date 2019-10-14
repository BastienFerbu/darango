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

  Future<Document> add(Map<String, dynamic> data,
    {bool waitForSync, bool returnNew, bool returnOld, bool silent, bool overwrite})async {
    String d = jsonEncode(data);
    String url = formatUrl("/_api/document/${collection.name}", waitForSync: waitForSync, 
      returnNew: returnNew, returnOld: returnOld, silent: silent, overwrite: overwrite);
    Request request = collection.client.prepareRequest(url, methode: "post");
    request.body = d;
    Map<dynamic, dynamic> doc = await collection.client.exec(request);
    this.id = doc.remove('_id');
    this.key = doc.remove('_key');
    this.rev = doc.remove('_rev');
    this.data = data;
    return this;
  }

  Future<Document> get() async{
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

  Future<Document> update(Map<String, dynamic> data, 
    {bool waitForSync, bool returnNew, bool returnOld, bool silent, bool overwrite, bool keepNull}) async{
    data.remove('_id');
    data.remove('_key');
    data.remove('_rev');
    String d = jsonEncode(data);
    Request request;
    String url = formatUrl("/_api/document/${this.id}", waitForSync: waitForSync, 
      returnNew: returnNew, returnOld: returnOld, silent: silent, overwrite: overwrite, keepNull: keepNull);
    request = collection.client.prepareRequest(url, methode: "patch");
    request.body = d;
    Map<dynamic, dynamic> doc = await collection.client.exec(request);
    this.data = data;
    //this.rev = doc.remove('_rev');
    return this;
  }

  String formatUrl(String url, {bool waitForSync, bool returnNew, 
    bool returnOld, bool silent, bool overwrite, bool ignoreRevs, bool mergeObjects, bool keepNull}){
    String formatedUrl = "$url?";
    if(waitForSync != null && waitForSync){formatedUrl += "waitForSync=true&";}
    if(returnNew != null && returnNew){formatedUrl += "returnNew=true&";}
    if(returnOld != null && returnOld){formatedUrl += "returnOld=true&";}
    if(silent != null && silent){formatedUrl += "silent=true&";}
    if(overwrite != null && overwrite){formatedUrl += "overwrite=true&";}
    if(ignoreRevs != null && ignoreRevs){formatedUrl += "ignoreRevs=true&";}
    if(mergeObjects != null && mergeObjects){formatedUrl += "mergeObjects=true&";}
    if(keepNull != null && keepNull){formatedUrl += "keepNull=true&";}
    formatedUrl = formatedUrl.substring(0, formatedUrl.length - 1);
    return formatedUrl;
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

  Future<Document> replace(Map<String, dynamic> data,
    {bool waitForSync, bool returnNew, bool returnOld, bool silent, bool overwrite}) async{
    data.remove('_id');
    data.remove('_key');
    data.remove('_rev');
    String d = jsonEncode(data);
    Request request;
    String url = formatUrl("/_api/document/${this.id}", waitForSync: waitForSync, 
      returnNew: returnNew, returnOld: returnOld, silent: silent, overwrite: overwrite);
    request = collection.client.prepareRequest("/_api/document/" + this.id, methode: "put");
    request.body = d;
    Map<dynamic, dynamic> doc = await collection.client.exec(request);
    this.data = data;
    //this.rev = doc.remove('_rev');
    return this;
  }

  Future<Document> replaceAllDocuments(Map<String, dynamic> data, String col,
    {bool waitForSync, bool returnNew, bool returnOld, bool ignoreRevs}) async{
    data.remove('_id');
    data.remove('_key');
    data.remove('_rev');
    String d = jsonEncode(data);
    Request request;
    String url = formatUrl("/_api/document/${col}", waitForSync: waitForSync, 
      returnNew: returnNew, returnOld: returnOld, ignoreRevs: ignoreRevs);
    request = collection.client.prepareRequest("/_api/document/" + this.id, methode: "put");
    request.body = d;
    Map<dynamic, dynamic> doc = await collection.client.exec(request);
    this.data = data;
    //this.rev = doc.remove('_rev');
    return this;
  }

  Future<Document> updateAllDocuments(Map<String, dynamic> data, String col, 
    {bool waitForSync, bool returnNew, bool returnOld, bool ignoreRevs, bool mergeObjects, bool keepNull}) async{
    data.remove('_id');
    data.remove('_key');
    data.remove('_rev');
    String d = jsonEncode(data);
    Request request;
    String url = formatUrl("/_api/document/${col}", waitForSync: waitForSync, 
      returnNew: returnNew, returnOld: returnOld, ignoreRevs: ignoreRevs, mergeObjects: mergeObjects, keepNull: keepNull);
    request = collection.client.prepareRequest(url, methode: "patch");
    request.body = d;
    Map<dynamic, dynamic> doc = await collection.client.exec(request);
    this.data = data;
    //this.rev = doc.remove('_rev');
    return this;
  }

}