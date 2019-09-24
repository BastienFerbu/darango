part of darango;

class Database {
  String url;
  String db_name;
  Uri uri;
  String path;
  String id; 
  String auth;
  bool isSystem;
  Client client = Client();

  Database(this.url);

  connect(db_name, username, password, {bool useBasic = true}) async{
    this.db_name = db_name;
    if(useBasic)
      this.auth = 'Basic ' + base64Encode(utf8.encode('$username:$password'));
    else{
      Response response = await post(this.url+"/_open/auth", body: {"username":"root","password":"24861793"});
      print(response.body);
    }
    this.uri = Uri.parse(this.url + "/_db/" + this.db_name);
    
    Map<String, dynamic> current = jsonDecode(await this.current());
    if(!current["error"]){
      this.path = current["result"]["path"];
      this.isSystem = current["result"]["isSystem"];
      this.id = current["result"]["id"];
    }
  }

  Uri concatUri(String p){
    return Uri(scheme: uri.scheme, host: uri.host, port: uri.port, path: uri.path + p);
  }

  Request makeRequest(Uri u, {String methode = "get"}){
    return Request(methode, u)..headers['Authorization'] = this.auth;
  }

  Future<String> current() async{
    Uri u = concatUri("/_api/database/current");
    Request request = makeRequest(u);
    StreamedResponse current = await client.send(request);
    String res = await current.stream.bytesToString();
    return res;
  }

  Collection collection(String name){
    return Collection(name);
  }
}