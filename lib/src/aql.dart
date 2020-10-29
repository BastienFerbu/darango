part of darango;

class Aql {
  ArangoClient client;
  Aql(this.client);

  Future<dynamic> run(String query,
      {bool count = true,
      int batchSize = 2,
      Map<String, dynamic> options}) async {
    var request = client.prepareRequest('/_api/cursor', methode: 'post');
    if (options != null) {
      request.body = jsonEncode({
        'query': query,
        'count': count,
        'batchSize': batchSize,
        'options': options
      });
    } else {
      request.body =
          jsonEncode({'query': query, 'count': count, 'batchSize': batchSize});
    }
    var doc = await client.exec(request);
    if (doc['error']) {
      print(doc['errorMessage']);
      return null;
    } else {
      return doc;
    }
  }

  Future<dynamic> explain(String query, {Map<String, dynamic> options}) async {
    var request = client.prepareRequest('/_api/explain', methode: 'post');
    if (options != null) {
      request.body = jsonEncode({'query': query, 'options': options});
    } else {
      request.body = jsonEncode({'query': query});
    }
    var doc = await client.exec(request);
    if (doc['error']) {
      print(doc['errorMessage']);
      return null;
    } else {
      return doc;
    }
  }

  Future<dynamic> parse(String query) async {
    var request = client.prepareRequest('/_api/query', methode: 'post');
    request.body = jsonEncode({'query': query});
    var doc = await client.exec(request);
    if (doc['error']) {
      print(doc['errorMessage']);
      return null;
    } else {
      return doc;
    }
  }

  Future<dynamic> nextBatch(String id) async {
    var request = client.prepareRequest('/_api/cursor/$id', methode: 'get');
    var doc = await client.exec(request);
    if (doc['error']) {
      print(doc['errorMessage']);
      return null;
    } else {
      return doc;
    }
  }
}
