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
    Map<String, dynamic> current = jsonDecode(await this.current());
    if(!current["error"]){
      this.path = current["result"]["path"];
      this.isSystem = current["result"]["isSystem"];
      this.id = current["result"]["id"];
    }
  }

  void close(){
    client.close();
  }


  Future<String> current() async{
    Request request = client.prepareRequest("/_api/database/current");
    StreamedResponse current = await client.send(request);
    String res = await current.stream.bytesToString();
    return res;
  }

  Collection collection(String name){
    return Collection(name, this.client);
  }

  Aql aql(){
    return Aql(this.client);
  }

  Graph graph(String name){
    return Graph(name, this.client);
  }
}