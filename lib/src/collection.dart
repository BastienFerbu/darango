part of darango;

class Collection {
  final String name;
  final String id;
  final bool isSystem;
  final int type;
  final int status;
  final String globallyUniqueId;
  ArangoClient client;

  Collection(
      {required this.name,
      required this.id,
      required this.isSystem,
      required this.type,
      required this.status,
      required this.globallyUniqueId,
      required this.client});

  /// Returns info of the collection
  FutureOr<String> info() async {
    var request = client.prepareRequest('/_api/collection/' + name);
    var streamedResponse = await client.send(request);
    var res = await streamedResponse.stream.bytesToString();
    return res;
  }

  /// Drop a collection
  FutureOr<Map<String, dynamic>?> drop() async {
    Map<String, dynamic>? res;
    try {
      var request =
          client.prepareRequest('/_api/collection/${name}', methode: 'delete');
      res = await client.exec(request);
    } catch (e) {
      print(e);
    }
    return res;
  }

  /// Truncate a collection
  FutureOr<Map<String, dynamic>?> truncate() async {
    Map<String, dynamic>? res;
    try {
      var request = client.prepareRequest('/_api/collection/${name}/truncate',
          methode: 'put');
      res = await client.exec(request);
    } catch (e) {
      print(e);
    }
    return res;
  }

  /// Returns properties of a collection
  FutureOr<Map<String, dynamic>?> properties({Map<String, dynamic>? prop}) async {
    Map<String, dynamic>? res;
    try {
      Request request;
      if (prop != null) {
        request = client.prepareRequest('/_api/collection/${name}/properties',
            methode: 'put');
        request.body = jsonEncode(prop);
      } else {
        request = client.prepareRequest('/_api/collection/${name}/properties',
            methode: 'get');
      }
      res = await client.exec(request);
    } catch (e) {
      print(e);
    }
    return res;
  }

  /// Count document of the collection
  FutureOr<Map<String, dynamic>?> count() async {
    Map<String, dynamic>? res;
    try {
      var request = client.prepareRequest('/_api/collection/${name}/properties',
          methode: 'get');
      res = await client.exec(request);
    } catch (e) {
      print(e);
    }
    return res;
  }

  /// Fetch the statistics of a collection
  FutureOr<Map<String, dynamic>?> figures() async {
    Map<String, dynamic>? res;
    try {
      var request = client.prepareRequest('/_api/collection/${name}/figures',
          methode: 'get');
      res = await client.exec(request);
    } catch (e) {
      print(e);
    }
    return res;
  }

  /// Return the responsible shard for a document
  FutureOr<Map<String, dynamic>?> responsibleShard() async {
    Map<String, dynamic>? res;
    try {
      var request = client.prepareRequest(
          '/_api/collection/${name}/responsibleShard',
          methode: 'put');
      res = await client.exec(request);
    } catch (e) {
      print(e);
    }
    return res;
  }

  /// Return the shard ids of a collection
  FutureOr<Map<String, dynamic>?> shards() async {
    Map<String, dynamic>? res;
    try {
      var request = client.prepareRequest('/_api/collection/${name}/shards',
          methode: 'get');
      res = await client.exec(request);
    } catch (e) {
      print(e);
    }
    return res;
  }

  /// Retrieve the collections revision id
  FutureOr<Map<String, dynamic>?> revision() async {
    Map<String, dynamic>? res;
    try {
      var request = client.prepareRequest('/_api/collection/${name}/revision',
          methode: 'get');
      res = await client.exec(request);
    } catch (e) {
      print(e);
    }
    return res;
  }

  /// Returns a checksum for the specified collection
  FutureOr<Map<String, dynamic>?> checksum() async {
    Map<String, dynamic>? res;
    try {
      var request = client.prepareRequest('/_api/collection/${name}/checksum',
          methode: 'get');
      res = await client.exec(request);
    } catch (e) {
      print(e);
    }
    return res;
  }

  /// Loads a collection
  FutureOr<Map<String, dynamic>?> load() async {
    Map<String, dynamic>? res;
    try {
      var request = client.prepareRequest('/_api/collection/${name}/load',
          methode: 'put');
      res = await client.exec(request);
    } catch (e) {
      print(e);
    }
    return res;
  }

  /// Unloads a collection
  FutureOr<Map<String, dynamic>?> unload() async {
    Map<String, dynamic>? res;
    try {
      var request = client.prepareRequest('/_api/collection/${name}/unload',
          methode: 'put');
      res = await client.exec(request);
    } catch (e) {
      print(e);
    }
    return res;
  }

  /// Rename a collection
  FutureOr<Map<String, dynamic>?> rename(String new_name) async {
    Map<String, dynamic>? res;
    try {
      var request = client.prepareRequest('/_api/collection/${name}/rename',
          methode: 'put');
      request.body = '{"name": $new_name}';
      res = await client.exec(request);
    } catch (e) {
      print(e);
    }
    return res;
  }

  /// Rotate a collection
  FutureOr<Map<String, dynamic>?> rotate() async {
    Map<String, dynamic>? res;
    try {
      var request = client.prepareRequest('/_api/collection/${name}/rotate',
          methode: 'put');
      res = await client.exec(request);
    } catch (e) {
      print(e);
    }
    return res;
  }

  FutureOr<Map<String, dynamic>?> recalculateCount() async {
    Map<String, dynamic>? res;
    try {
      var request = client.prepareRequest(
          '/_api/collection/${name}/recalculateCount',
          methode: 'put');
      res = (await client.exec(request)).cast<String, dynamic>();
    } catch (e) {
      print(e);
    }
    return res;
  }

  /// Return a document of the collection
  ///
  /// document_handle can be either _id or _key
  Document document({String? document_handle}) {
    String key, id;
    if (document_handle == null) {
      return Document(collection: this);
    }
    if (document_handle.contains('/')) {
      id = document_handle;
      var list = document_handle.split('/');
      key = list[1];
    } else {
      key = document_handle;
      id = '${name}/${key}';
    }
    return Document(collection: this, key: key, id: id);
  }
}
