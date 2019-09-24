/*part of darango;

class ArangoClient extends BaseClient{
  String auth;
  Client _inner = Client();
  String url;

  ArangoClient(this.url);

  @override
  void close(){
    _inner.close();
    super.close();
  }

  Future<StreamedResponse> send(BaseRequest request) {
    return _inner.send(request);
  }

  Database db(){
    Database db = Database(url);
  }
}*/