part of darango;

class Graph {
  String name;
  String id;
  String key;
  String rev;
  int replicationFactor;
  int minReplicationFactor;
  int numberOfShards;
  bool isSmart;
  List orphanCollections; 
  dynamic edgeDefinitions;

  ArangoClient client;

  Graph({this.name, this.id, this.key, this.rev, this.replicationFactor, this.minReplicationFactor, 
    this.numberOfShards, this.isSmart, this.orphanCollections, this.edgeDefinitions, this.client});
  
  Future<Graph> get() async{
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

  Future<Map<String, dynamic>> drop() async{
    /// Drop a collection
    Map<String, dynamic> res;
    try {
      Request request = client.prepareRequest("/_api/gharial/${this.name}", methode: "delete");
      res = await client.exec(request);
    } catch (e) {
      print(e);
    }
    return res;
  }

  Future<Map<String, dynamic>> vertexCollection({Map<String, dynamic> prop}) async{
    /// Properties of a collection
    Map<String, dynamic> res;
    try {
      Request request;
      if(prop != null){
        request = client.prepareRequest("/_api/gharial/${this.name}/vertex", methode: "post");
        request.body = jsonEncode(prop);
      }
      else{
        request = client.prepareRequest("/_api/gharial/${this.name}/vertex", methode: "get");
      }
      res = await client.exec(request);
    } catch (e) {
      print(e);
    }
    return res;
  }

  Future<Map<String, dynamic>> dropVertexCollection(String collection) async{
    /// Drop a collection
    Map<String, dynamic> res;
    try {
      Request request = client.prepareRequest("/_api/gharial/${this.name}/vertex/$collection", methode: "delete");
      res = await client.exec(request);
    } catch (e) {
      print(e);
    }
    return res;
  }

  Future<Map<String, dynamic>> edgeDefinition({Map<String, dynamic> prop}) async{
    /// Properties of a collection
    Map<String, dynamic> res;
    try {
      Request request;
      if(prop != null){
        request = client.prepareRequest("/_api/gharial/${this.name}/edge", methode: "post");
        request.body = jsonEncode(prop);
      }
      else{
        request = client.prepareRequest("/_api/gharial/${this.name}/edge", methode: "get");
      }
      res = await client.exec(request);
    } catch (e) {
      print(e);
    }
    return res;
  }

  Future<Map<String, dynamic>> replaceEdgeDefinition(String definition, Map<String, dynamic> data) async{
    /// Properties of a collection
    Map<String, dynamic> res;
    try {
      Request request = client.prepareRequest("/_api/gharial/${this.name}/edge/$definition", methode: "put");
      request.body = jsonEncode(data);
      res = await client.exec(request);
    } catch (e) {
      print(e);
    }
    return res;
  }

  Future<Map<String, dynamic>> removeEdgeDefinition(String definition) async{
    /// Properties of a collection
    Map<String, dynamic> res;
    try {
      Request request = client.prepareRequest("/_api/gharial/${this.name}/edge/$definition", methode: "delete");
      res = await client.exec(request);
    } catch (e) {
      print(e);
    }
    return res;
  }

  //------------------------------CRUD VERTEX----------------------------------------------------------------------

  Future<Map<String, dynamic>> createVertex(String collection, Map<String, dynamic> data) async{
    /// Properties of a collection
    Map<String, dynamic> res;
    try {
      Request request = client.prepareRequest("/_api/gharial/${this.name}/vertex/$collection", methode: "post");
      request.body = jsonEncode(data);
      res = await client.exec(request);
    } catch (e) {
      print(e);
    }
    return res;
  }

  Future<Map<String, dynamic>> getVertex(String collection, String vertex) async{
    /// Properties of a collection
    Map<String, dynamic> res;
    try {
      Request request = client.prepareRequest("/_api/gharial/${this.name}/vertex/$collection/$vertex", methode: "get");
      res = await client.exec(request);
    } catch (e) {
      print(e);
    }
    return res;
  }

  Future<Map<String, dynamic>> updateVertex(String collection, String vertex, Map<String, dynamic> data) async{
    /// Properties of a collection
    Map<String, dynamic> res;
    try {
      Request request = client.prepareRequest("/_api/gharial/${this.name}/vertex/$collection/$vertex", methode: "patch");
      request.body = jsonEncode(data);
      res = await client.exec(request);
    } catch (e) {
      print(e);
    }
    return res;
  }

  Future<Map<String, dynamic>> removeVertex(String collection, String vertex) async{
    /// Properties of a collection
    Map<String, dynamic> res;
    try {
      Request request = client.prepareRequest("/_api/gharial/${this.name}/vertex/$collection/$vertex", methode: "get");
      res = await client.exec(request);
    } catch (e) {
      print(e);
    }
    return res;
  }

  //------------------------------CRUD EDGE------------------------------------------------------------------------

  Future<Map<String, dynamic>> createEdge(String collection, Map<String, dynamic> data) async{
    /// Properties of a collection
    Map<String, dynamic> res;
    try {
      Request request = client.prepareRequest("/_api/gharial/${this.name}/edge/$collection", methode: "post");
      request.body = jsonEncode(data);
      res = await client.exec(request);
    } catch (e) {
      print(e);
    }
    return res;
  }

  Future<Map<String, dynamic>> getEdge(String collection, String edge) async{
    /// Properties of a collection
    Map<String, dynamic> res;
    try {
      Request request = client.prepareRequest("/_api/gharial/${this.name}/edge/$collection/$edge", methode: "get");
      res = await client.exec(request);
    } catch (e) {
      print(e);
    }
    return res;
  }

  Future<Map<String, dynamic>> updateEdge(String collection, String edge, Map<String, dynamic> data) async{
    /// Properties of a collection
    Map<String, dynamic> res;
    try {
      Request request = client.prepareRequest("/_api/gharial/${this.name}/edge/$collection/$edge", methode: "patch");
      request.body = jsonEncode(data);
      res = await client.exec(request);
    } catch (e) {
      print(e);
    }
    return res;
  }

  Future<Map<String, dynamic>> removeEdge(String collection, String edge) async{
    /// Properties of a collection
    Map<String, dynamic> res;
    try {
      Request request = client.prepareRequest("/_api/gharial/${this.name}/edge/$collection/$edge", methode: "get");
      res = await client.exec(request);
    } catch (e) {
      print(e);
    }
    return res;
  }
}