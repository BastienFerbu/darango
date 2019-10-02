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
      Response response = await post(this.url+"/_open/auth", body: {"username":"root","password":"24861793"});
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
      print(current["errorMessage"]);
      return false;
    }
  }

  void close(){
    client.close();
  }


  Future<Map<String, dynamic>> current() async{
    Map<String, dynamic> res;
    try {
      Request request = client.prepareRequest("/_api/database/current");
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
      collection = Collection(name, doc["id"], doc["isSystem"], doc["type"], doc["status"], doc["globallyUniqueId"], this.client);
    } catch (e) {
      print(e);
    }
    return collection;
  }

  Aql aql(){
    return Aql(this.client);
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