part of darango;

class ArangoClient extends BaseClient{
  String auth;
  Client _inner = Client();
  Uri uri;

  ArangoClient(this.auth, this.uri);

  @override
  void close(){
    _inner.close();
    super.close();
  }

  Uri concatUri(String p){
    return Uri(scheme: uri.scheme, host: uri.host, port: uri.port, path: uri.path + p);
  }

  Request prepareRequest(String url, {String methode = "get", String content_type = "application/json"}){
    Uri u  = concatUri(url);
    return Request(methode, u)..headers['Authorization'] = this.auth..headers['Content-Type'] = content_type;
  }

  Future<StreamedResponse> send(BaseRequest request) {
    return _inner.send(request);
  }

}