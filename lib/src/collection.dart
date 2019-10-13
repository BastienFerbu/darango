part of darango;

class Collection {
  final String name;
  final String id;
  final bool isSystem;
  final int type;
  final int status;
  final String globallyUniqueId;
  ArangoClient client;

  Collection({this.name, this.id, this.isSystem, this.type, this.status, this.globallyUniqueId, this.client});


  Future<String> infos() async {
    Request request = client.prepareRequest("/_api/collection/"+this.name);
    StreamedResponse current = await client.send(request);
    String res = await current.stream.bytesToString();
    return res;
  }

  Future<Map<String, dynamic>> drop() async{
    /// Drop a collection
    Map<String, dynamic> res;
    try {
      Request request = client.prepareRequest("/_api/collection/${this.name}", methode: "delete");
      res = await client.exec(request);
    } catch (e) {
      print(e);
    }
    return res;
  }

  Future<Map<String, dynamic>> truncate() async{
    /// Truncate a collection
    Map<String, dynamic> res;
    try {
      Request request = client.prepareRequest("/_api/collection/${this.name}/truncate", methode: "put");
      res = await client.exec(request);
    } catch (e) {
      print(e);
    }
    return res;
  }

  Future<Map<String, dynamic>> properties({Map<String, dynamic> prop}) async{
    /// Properties of a collection
    Map<String, dynamic> res;
    try {
      Request request;
      if(prop != null){
        request = client.prepareRequest("/_api/collection/${this.name}/properties", methode: "put");
        request.body = jsonEncode(prop);
      }
      else{
        request = client.prepareRequest("/_api/collection/${this.name}/properties", methode: "get");
      }
      res = await client.exec(request);
    } catch (e) {
      print(e);
    }
    return res;
  }

  Future<Map<String, dynamic>> count() async{
    /// Count document of the collection
    Map<String, dynamic> res;
    try {
      Request request = client.prepareRequest("/_api/collection/${this.name}/properties", methode: "get");
      res = await client.exec(request);
    } catch (e) {
      print(e);
    }
    return res;
  }

  Future<Map<String, dynamic>> figures() async{
    /// Fetch the statistics of a collection
    Map<String, dynamic> res;
    try {
      Request request = client.prepareRequest("/_api/collection/${this.name}/figures", methode: "get");
      res = await client.exec(request);
    } catch (e) {
      print(e);
    }
    return res;
  }

  Future<Map<String, dynamic>> responsibleShard() async{
    /// Return the responsible shard for a document
    Map<String, dynamic> res;
    try {
      Request request = client.prepareRequest("/_api/collection/${this.name}/responsibleShard", methode: "put");
      res = await client.exec(request);
    } catch (e) {
      print(e);
    }
    return res;
  }

  Future<Map<String, dynamic>> shards() async{
    /// Return the shard ids of a collection
    Map<String, dynamic> res;
    try {
      Request request = client.prepareRequest("/_api/collection/${this.name}/shards", methode: "get");
      res = await client.exec(request);
    } catch (e) {
      print(e);
    }
    return res;
  }

  Future<Map<String, dynamic>> revision() async{
    /// Retrieve the collections revision id
    Map<String, dynamic> res;
    try {
      Request request = client.prepareRequest("/_api/collection/${this.name}/revision", methode: "get");
      res = await client.exec(request);
    } catch (e) {
      print(e);
    }
    return res;
  }

  Future<Map<String, dynamic>> checksum() async{
    /// Returns a checksum for the specified collection
    Map<String, dynamic> res;
    try {
      Request request = client.prepareRequest("/_api/collection/${this.name}/checksum", methode: "get");
      res = await client.exec(request);
    } catch (e) {
      print(e);
    }
    return res;
  }

  Future<Map<String, dynamic>> load() async{
    /// Loads a collection
    Map<String, dynamic> res;
    try {
      Request request = client.prepareRequest("/_api/collection/${this.name}/load", methode: "put");
      res = await client.exec(request);
    } catch (e) {
      print(e);
    }
    return res;
  }

  Future<Map<String, dynamic>> unload() async{
    /// Unloads a collection
    Map<String, dynamic> res;
    try {
      Request request = client.prepareRequest("/_api/collection/${this.name}/unload", methode: "put");
      res = await client.exec(request);
    } catch (e) {
      print(e);
    }
    return res;
  }

  Future<Map<String, dynamic>> rename(String new_name) async{
    /// Rename a collection
    Map<String, dynamic> res;
    try {
      Request request = client.prepareRequest("/_api/collection/${this.name}/rename", methode: "put");
      request.body = '{"name": $new_name}';
      res = await client.exec(request);
    } catch (e) {
      print(e);
    }
    return res;
  }

  Future<Map<String, dynamic>> rotate() async{
    Map<String, dynamic> res;
    try {
      Request request = client.prepareRequest("/_api/collection/${this.name}/rotate", methode: "put");
      res = await client.exec(request);
    } catch (e) {
      print(e);
    }
    return res;
  }

  Future<Map<String, dynamic>> recalculateCount() async{
    Map<String, dynamic> res;
    try {
      Request request = client.prepareRequest("/_api/collection/${this.name}/recalculateCount", methode: "put");
      res = await client.exec(request);
    } catch (e) {
      print(e);
    }
    return res;
  }

  Document document({String document_handle = null}) {
    String key, id;
    if(document_handle == null)
      return Document(collection: this);
    if(document_handle.contains('/')){
      id = document_handle;
      List<String> list = document_handle.split("/");
      key = list[1];
    }else{
      key = document_handle;
      id = "${this.name}/${key}";
    }
    return Document(collection: this, key: key, id: id);
  }
}