part of darango;

class ArangoClient extends BaseClient {
  final String? auth;
  final Client _inner = Client();
  final Uri uri;

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
    var request = Request(methode, u);
    if (auth != null) request.headers['Authorization'] = auth!;
    request.headers['Content-Type'] = content_type;
    return request;
  }

  /// Sends the http request and returns the response as a Map
  Future<Map<String, dynamic>> exec(Request request) async {
    var response = await send(request);
    var doc_str = await response.stream.bytesToString();
    Map<String, dynamic> doc = jsonDecode(doc_str);
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
