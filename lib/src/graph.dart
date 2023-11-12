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

  Graph(
      {required this.name,
      required this.id,
      required this.key,
      required this.rev,
      required this.replicationFactor,
      required this.minReplicationFactor,
      required this.numberOfShards,
      required this.isSmart,
      required this.orphanCollections,
      required this.edgeDefinitions,
      required this.client});

  FutureOr<Graph> get() async {
    var request = client.prepareRequest('/_api/gharial/' + name);
    var streamedResponse = await client.send(request);
    var doc_str = await streamedResponse.stream.bytesToString();
    Map<dynamic, dynamic> doc = jsonDecode(doc_str);
    id = doc.remove('_id');
    key = doc.remove('_key');
    rev = doc.remove('_rev');
    name = doc.remove('name');
    return this;
  }

  /// Drop a graph
  FutureOr<Map<String, dynamic>?> drop() async {
    Map<String, dynamic>? res;
    try {
      var request =
          client.prepareRequest('/_api/gharial/${name}', methode: 'delete');
      res = await client.exec(request);
    } catch (e) {
      print(e);
    }
    return res;
  }

  /// Returns the vertex collection
  FutureOr<Map<String, dynamic>?> vertexCollection(
      {Map<String, dynamic>? prop}) async {
    Map<String, dynamic>? res;
    try {
      Request request;
      if (prop != null) {
        request = client.prepareRequest('/_api/gharial/${name}/vertex',
            methode: 'post');
        request.body = jsonEncode(prop);
      } else {
        request = client.prepareRequest('/_api/gharial/${name}/vertex',
            methode: 'get');
      }
      res = await client.exec(request);
    } catch (e) {
      print(e);
    }
    return res;
  }

  /// Drop vertex of a collection
  FutureOr<Map<String, dynamic>?> dropVertexCollection(String collection) async {
    Map<String, dynamic>? res;
    try {
      var request = client.prepareRequest(
          '/_api/gharial/${name}/vertex/$collection',
          methode: 'delete');
      res = await client.exec(request);
    } catch (e) {
      print(e);
    }
    return res;
  }

  /// Returns edge definition
  FutureOr<Map<String, dynamic>?> edgeDefinition(
      {Map<String, dynamic>? prop}) async {
    Map<String, dynamic>? res;
    try {
      Request request;
      if (prop != null) {
        request = client.prepareRequest('/_api/gharial/${name}/edge',
            methode: 'post');
        request.body = jsonEncode(prop);
      } else {
        request =
            client.prepareRequest('/_api/gharial/${name}/edge', methode: 'get');
      }
      res = await client.exec(request);
    } catch (e) {
      print(e);
    }
    return res;
  }

  /// Replaces edge definition
  FutureOr<Map<String, dynamic>?> replaceEdgeDefinition(
      String definition, Map<String, dynamic> data) async {
    Map<String, dynamic>? res;
    try {
      var request = client.prepareRequest(
          '/_api/gharial/${name}/edge/$definition',
          methode: 'put');
      request.body = jsonEncode(data);
      res = await client.exec(request);
    } catch (e) {
      print(e);
    }
    return res;
  }

  /// Removes edge definition
  FutureOr<Map<String, dynamic>?> removeEdgeDefinition(String definition) async {
    Map<String, dynamic>? res;
    try {
      var request = client.prepareRequest(
          '/_api/gharial/${name}/edge/$definition',
          methode: 'delete');
      res = await client.exec(request);
    } catch (e) {
      print(e);
    }
    return res;
  }

  //------------------------------CRUD VERTEX----------------------------------------------------------------------

  /// Creates a vertex
  FutureOr<Map<String, dynamic>?> createVertex(
      String collection, Map<String, dynamic> data) async {
    Map<String, dynamic>? res;
    try {
      var request = client.prepareRequest(
          '/_api/gharial/${name}/vertex/$collection',
          methode: 'post');
      request.body = jsonEncode(data);
      res = await client.exec(request);
    } catch (e) {
      print(e);
    }
    return res;
  }

  /// Get a vertex
  FutureOr<Map<String, dynamic>?> getVertex(
      String collection, String vertex) async {
    Map<String, dynamic>? res;
    try {
      var request = client.prepareRequest(
          '/_api/gharial/${name}/vertex/$collection/$vertex',
          methode: 'get');
      res = await client.exec(request);
    } catch (e) {
      print(e);
    }
    return res;
  }

  /// Updates a vertex
  FutureOr<Map<String, dynamic>?> updateVertex(
      String collection, String vertex, Map<String, dynamic> data) async {
    Map<String, dynamic>? res;
    try {
      var request = client.prepareRequest(
          '/_api/gharial/${name}/vertex/$collection/$vertex',
          methode: 'patch');
      request.body = jsonEncode(data);
      res = await client.exec(request);
    } catch (e) {
      print(e);
    }
    return res;
  }

  /// Removes a vertex
  FutureOr<Map<String, dynamic>?> removeVertex(
      String collection, String vertex) async {
    Map<String, dynamic>? res;
    try {
      var request = client.prepareRequest(
          '/_api/gharial/${name}/vertex/$collection/$vertex',
          methode: 'get');
      res = await client.exec(request);
    } catch (e) {
      print(e);
    }
    return res;
  }

  //------------------------------CRUD EDGE------------------------------------------------------------------------

  /// Creates an edge
  FutureOr<Map<String, dynamic>?> createEdge(
      String collection, Map<String, dynamic> data) async {
    Map<String, dynamic>? res;
    try {
      var request = client.prepareRequest(
          '/_api/gharial/${name}/edge/$collection',
          methode: 'post');
      request.body = jsonEncode(data);
      res = await client.exec(request);
    } catch (e) {
      print(e);
    }
    return res;
  }

  /// Get an edge
  FutureOr<Map<String, dynamic>?> getEdge(String collection, String edge) async {
    Map<String, dynamic>? res;
    try {
      var request = client.prepareRequest(
          '/_api/gharial/${name}/edge/$collection/$edge',
          methode: 'get');
      res = await client.exec(request);
    } catch (e) {
      print(e);
    }
    return res;
  }

  /// Updates an edge
  FutureOr<Map<String, dynamic>?> updateEdge(
      String collection, String edge, Map<String, dynamic> data) async {
    Map<String, dynamic>? res;
    try {
      var request = client.prepareRequest(
          '/_api/gharial/${name}/edge/$collection/$edge',
          methode: 'patch');
      request.body = jsonEncode(data);
      res = await client.exec(request);
    } catch (e) {
      print(e);
    }
    return res;
  }

  /// Removes an edge
  FutureOr<Map<String, dynamic>?> removeEdge(
      String collection, String edge) async {
    Map<String, dynamic>? res;
    try {
      var request = client.prepareRequest(
          '/_api/gharial/${name}/edge/$collection/$edge',
          methode: 'get');
      res = await client.exec(request);
    } catch (e) {
      print(e);
    }
    return res;
  }
}
