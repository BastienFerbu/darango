part of darango;

class Database {
  String url;
  String db_name;
  Uri uri;
  String path;
  String id; 
  String auth;
  bool isSystem;
  ArangoClient client;

  Database(this.url);

  Future<bool> connect(db_name, username, password, {bool useBasic = true}) async{
    this.db_name = db_name;
    if(useBasic)
      this.auth = 'Basic ' + base64Encode(utf8.encode('$username:$password'));
    else{
      Response response = await post(this.url+"/_open/auth", body: {"username":"$username","password":"$password"});
      print(response.body);
    }
    this.uri = Uri.parse(this.url + "/_db/" + this.db_name);
    
    this.client = ArangoClient(this.auth, this.uri);
    Map<String, dynamic> current = await this.current();
    if(current != null && !current["error"]){
      this.path = current["result"]["path"];
      this.isSystem = current["result"]["isSystem"];
      this.id = current["result"]["id"];
      return true;
    }
    else{
      throw ClientException(current["errorMessage"], this.uri);
      //return false;
    }
  }

  void close(){
    client.close();
  }


  Future<Map<String, dynamic>> current() async{
    /// Retrieve the current database information
    Map<String, dynamic> res;
    try {
      Request request = client.prepareRequest("/_api/database/current");
      res = await client.exec(request);
    } catch (e) {
      print(e);
    }
    return res;
  }

  Future<Map<String, dynamic>> users() async{
    /// Retrieves a list of all databases the current user can access
    Map<String, dynamic> res;
    try {
      Request request = client.prepareRequest("/_api/database/user");
      res = await client.exec(request);
    } catch (e) {
      print(e);
    }
    return res;
  }

  Future<Map<String, dynamic>> databases() async{
    /// Retrieves a list of all existing databases
    Map<String, dynamic> res;
    try {
      Request request = client.prepareRequest("/_api/database");
      res = await client.exec(request);
    } catch (e) {
      print(e);
    }
    return res;
  }

  Future<Map<String, dynamic>> create(Map<String, dynamic> data) async{
    /// Create a database
    Map<String, dynamic> res;
    String d = jsonEncode(data);
    try {
      Request request = client.prepareRequest("/_api/database", methode: "post");
      request.body = d;
      res = await client.exec(request);
    } catch (e) {
      print(e);
    }
    return res;
  }

  Future<Collection> createCollection(Map<String, dynamic> data) async{
    /// Create collection
    Map<String, dynamic> res;
    Collection collection;
    String d = jsonEncode(data);
    try {
      Request request = client.prepareRequest("/_api/collection", methode: "post");
      request.body = d;
      res = await client.exec(request);
      collection = Collection(name: res["name"], id: res["id"], isSystem: res["isSystem"], type: res["type"], status: res["status"], globallyUniqueId: res["globallyUniqueId"], client: this.client);
    } catch (e) {
      print(e);
      return null;
    }
    return collection;
  }

  Future<Map<String, dynamic>> drop(String database_name) async{
    /// Drop a database
    Map<String, dynamic> res;
    try {
      Request request = client.prepareRequest("/_api/database/$database_name", methode: "delete");
      res = await client.exec(request);
    } catch (e) {
      print(e);
    }
    return res;
  }

  Future<Collection> collection(String name) async{
    Request request = client.prepareRequest("/_api/collection/" + name, methode: "get");
    Collection collection;
    try {
      Map<dynamic, dynamic> doc = await client.exec(request);
      collection = Collection(name: name, id: doc["id"], isSystem: doc["isSystem"], type: doc["type"], status: doc["status"], globallyUniqueId: doc["globallyUniqueId"], client: this.client);
    } catch (e) {
      print(e);
    }
    return collection;
  }

  Aql aql(){
    return Aql(this.client);
  }

  Transaction transaction(){
    return Transaction(this.client);
  }

  Future<Graph> graph(String name) async{
    Request request = client.prepareRequest("/_api/gharial/" + name, methode: "get");
    Map<dynamic, dynamic> doc = await client.exec(request);
    if(doc != null){
      Graph graph = Graph(name, doc["_id"], doc["_key"], doc["_rev"],doc["replicationFactor"], doc["minReplicationFactor"], 
        doc["numberOfShards"],  doc["isSmart"], doc["orphanCollections"], doc["edgeDefinitions"], this.client);
      return graph;
    }
    else{
      return null;
    }
  }
}