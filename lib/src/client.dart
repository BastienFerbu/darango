part of darango;

class ArangoClient extends BaseClient {
  String auth;
  final Client _inner = Client();
  Uri uri;

  ArangoClient(this.auth, this.uri);

  @override
  void close() {
    _inner.close();
    super.close();
  }

  /// Concat a string to the main URL of the db
  Uri concatUri(String p) {
    return Uri(
        scheme: uri.scheme, host: uri.host, port: uri.port, path: uri.path + p);
  }

  /// Prepares a http request
  Request prepareRequest(String url,
      {String methode = 'get', String content_type = 'application/json'}) {
    var u = concatUri(url);
    return Request(methode, u)
      ..headers['Authorization'] = auth
      ..headers['Content-Type'] = content_type;
  }

  /// Sends the http request and returns the response as a Map
  Future<Map<dynamic, dynamic>> exec(Request request) async {
    var response = await send(request);
    var doc_str = await response.stream.bytesToString();
    Map<dynamic, dynamic> doc = jsonDecode(doc_str);
    if (doc['error'] != null && doc['error']) {
      var message = 'ClientException : ${doc['errorMessage']} [${doc['code']}]';
      throw ClientException(message, request.url);
      //return null;
    } else {
      return doc;
    }
  }

  /// Sends the http request
  @override
  Future<StreamedResponse> send(BaseRequest request) {
    return _inner.send(request);
  }
}
