part of darango;

enum ConnectionState { connected, not_connected }

class Database {
  final String url;
  late String db_name;
  late Uri uri;
  late String path;
  late String id;
  String? auth;
  ConnectionState state = ConnectionState.not_connected;
  late bool isSystem;
  late ArangoClient client;

  Database(this.url);

  /// Connect to the db
  Future<bool> connect(db_name, username, password,
      {bool useBasic = true}) async {
    this.db_name = db_name;
    if (useBasic) {
      auth = 'Basic ' + base64Encode(utf8.encode('$username:$password'));
    } else {
      var response = await post(Uri.parse(url + '/_open/auth'),
          body: {'username': '$username', 'password': '$password'});
      print(response.body);
    }
    uri = Uri.parse(url + '/_db/' + this.db_name!);

    client = ArangoClient(auth, uri!);
    var current = await this.current();
    if (current != null && !current['error']) {
      state = ConnectionState.connected;
      path = current['result']['path'];
      isSystem = current['result']['isSystem'];
      id = current['result']['id'];
      return true;
    } else {
      throw ClientException('No connection', uri);
    }
  }

  /// Close the connection to the db
  void close() {
    client.close();
  }

  /// Retrieve the current database information
  Future<Map<String, dynamic>?> current() async {
    Map<String, dynamic>? res;
    try {
      var request = client.prepareRequest('/_api/database/current');
      res = await client.exec(request);
    } catch (e) {
      print(e);
    }
    return res;
  }

  /// Retrieves a list of all databases the current user can access
  Future<Map<String, dynamic>?> users() async {
    Map<String, dynamic>? res;
    try {
      var request = client.prepareRequest('/_api/database/user');
      res = await client.exec(request);
    } catch (e) {
      print(e);
    }
    return res;
  }

  /// Retrieves a list of all existing databases
  Future<Map<String, dynamic>?> databases() async {
    Map<String, dynamic>? res;
    try {
      var request = client.prepareRequest('/_api/database');
      res = await client.exec(request);
    } catch (e) {
      print(e);
    }
    return res;
  }

  /// Create a database
  Future<Map<String, dynamic>?> create(Map<String, dynamic> data) async {
    Map<String, dynamic>? res;
    var d = jsonEncode(data);
    try {
      var request = client.prepareRequest('/_api/database', methode: 'post');
      request.body = d;
      res = await client.exec(request);
    } catch (e) {
      print(e);
    }
    return res;
  }

  /// Drop a database
  Future<Map<String, dynamic>?> drop(String database_name) async {
    Map<String, dynamic>? res;
    try {
      var request = client.prepareRequest('/_api/database/$database_name',
          methode: 'delete');
      res = await client.exec(request);
    } catch (e) {
      print(e);
    }
    return res;
  }

  /// Returns a collection of the db
  Future<Collection?> collection(String name) async {
    var request =
        client.prepareRequest('/_api/collection/' + name, methode: 'get');
    Collection? collection;
    try {
      var doc = await client.exec(request);
      collection = Collection(
          name: name,
          id: doc['id'],
          isSystem: doc['isSystem'],
          type: doc['type'],
          status: doc['status'],
          globallyUniqueId: doc['globallyUniqueId'],
          client: client);
    } catch (e) {
      print(e);
    }
    return collection;
  }

  /// Returns an Aql object in order to use AQL query
  Aql aql() {
    return Aql(client);
  }

  /// Returns an Transaction object in order to use transaction
  Transaction transaction() {
    return Transaction(client);
  }

  /// Returns an Graph object in order to use graph
  Future<Graph?> graph(String name) async {
    var request =
        client.prepareRequest('/_api/gharial/' + name, methode: 'get');
    var doc = await client.exec(request);
    if (doc != null) {
      var graph = Graph(
          name: name,
          id: doc['_id'],
          key: doc['_key'],
          rev: doc['_rev'],
          replicationFactor: doc['replicationFactor'],
          minReplicationFactor: doc['minReplicationFactor'],
          numberOfShards: doc['numberOfShards'],
          isSmart: doc['isSmart'],
          orphanCollections: doc['orphanCollections'],
          edgeDefinitions: doc['edgeDefinitions'],
          client: client);
      return graph;
    } else {
      return null;
    }
  }

  /// Create collection
  Future<Collection?> createCollection(Map<String, dynamic> data) async {
    Map<String, dynamic> res;
    Collection collection;
    var d = jsonEncode(data);
    try {
      var request = client.prepareRequest('/_api/collection', methode: 'post');
      request.body = d;
      res = await client.exec(request);
      collection = Collection(
          name: res['name'],
          id: res['id'],
          isSystem: res['isSystem'],
          type: res['type'],
          status: res['status'],
          globallyUniqueId: res['globallyUniqueId'],
          client: client);
    } catch (e) {
      print(e);
      return null;
    }
    return collection;
  }

  /// Create graph
  Future<Graph?> createGraph(Map<String, dynamic> data) async {
    Map<String, dynamic> doc;
    Graph graph;
    var d = jsonEncode(data);
    try {
      var request = client.prepareRequest('/_api/gharial', methode: 'post');
      request.body = d;
      doc = await client.exec(request);
      graph = Graph(
          name: doc['name'],
          id: doc['_id'],
          key: doc['_key'],
          rev: doc['_rev'],
          replicationFactor: doc['replicationFactor'],
          minReplicationFactor: doc['minReplicationFactor'],
          numberOfShards: doc['numberOfShards'],
          isSmart: doc['isSmart'],
          orphanCollections: doc['orphanCollections'],
          edgeDefinitions: doc['edgeDefinitions'],
          client: client);
    } catch (e) {
      print(e);
      return null;
    }
    return graph;
  }

  /// Returns all collections
  Future<Map<String, dynamic>?> collections() async {
    Map<String, dynamic>? res;
    try {
      var request = client.prepareRequest('/_api/collection', methode: 'get');
      res = await client.exec(request);
    } catch (e) {
      print(e);
    }
    return res;
  }

  /// Returns all graphs
  Future<Map<String, dynamic>?> graphs() async {
    Map<String, dynamic>? res;
    try {
      var request = client.prepareRequest('/_api/gharial', methode: 'get');
      res = await client.exec(request);
    } catch (e) {
      print(e);
    }
    return res;
  }

  /// Returns all edges
  Future<Map<String, dynamic>?> edges(String collection, String vertex,
      {String? direction}) async {
    Map<String, dynamic>? res;
    try {
      Request request;
      if (direction != null) {
        request = client.prepareRequest('/_api/edges/$id?vertex=$vertex',
            methode: 'get');
      } else {
        request = client.prepareRequest(
            '/_api/edges/$id?vertex=$vertex&direction=$direction',
            methode: 'get');
      }
      res = await client.exec(request);
    } catch (e) {
      print(e);
    }
    return res;
  }
}
