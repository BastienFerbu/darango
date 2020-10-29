part of darango;

class Document {
  String id;
  String key;
  String rev;
  dynamic data;
  Collection collection;

  Document({this.collection, this.key, this.id});

  /// Returns a Map of the Document itself
  Map<String, dynamic> toMap({var separated = false}) {
    Map<String, dynamic> doc;
    if (!separated) {
      doc = data;
      doc['_id'] = id;
      doc['_key'] = key;
      doc['_rev'] = rev;
    } else {
      doc = {'_id': id, '_key': key, '_rev': rev, 'data': data};
    }
    return doc;
  }

  @override
  String toString({var separated = false}) =>
      toMap(separated: separated).toString();

  /// Add a document in the colleciton
  Future<Document> add(Map<String, dynamic> data,
      {bool waitForSync,
      bool returnNew,
      bool returnOld,
      bool silent,
      bool overwrite}) async {
    var d = jsonEncode(data);
    var url = formatUrl('/_api/document/${collection.name}',
        waitForSync: waitForSync,
        returnNew: returnNew,
        returnOld: returnOld,
        silent: silent,
        overwrite: overwrite);
    var request = collection.client.prepareRequest(url, methode: 'post');
    request.body = d;
    Map<dynamic, dynamic> doc;
    doc = await collection.client.exec(request);
    id = doc.remove('_id');
    key = doc.remove('_key');
    rev = doc.remove('_rev');
    this.data = data;
    return this;
  }

  /// Get a document
  Future<Document> get() async {
    var request = collection.client.prepareRequest('/_api/document/${id}');
    var streamedResponse = await collection.client.send(request);
    var doc_str = await streamedResponse.stream.bytesToString();
    Map<dynamic, dynamic> doc = jsonDecode(doc_str);
    //this.id = doc.remove('_id');
    //this.key = doc.remove('_key');
    rev = doc.remove('_rev');
    data = doc;
    return this;
  }

  /// Updates a document
  Future<Document> update(Map<String, dynamic> data,
      {bool waitForSync,
      bool returnNew,
      bool returnOld,
      bool silent,
      bool overwrite,
      bool keepNull}) async {
    data.remove('_id');
    data.remove('_key');
    data.remove('_rev');
    var d = jsonEncode(data);
    Request request;
    var url = formatUrl('/_api/document/${id}',
        waitForSync: waitForSync,
        returnNew: returnNew,
        returnOld: returnOld,
        silent: silent,
        overwrite: overwrite,
        keepNull: keepNull);
    request = collection.client.prepareRequest(url, methode: 'patch');
    request.body = d;
    await collection.client.exec(request);
    this.data = data;
    //this.rev = doc.remove('_rev');
    return this;
  }

  /// Formats an url for the http request with parameters
  String formatUrl(String url,
      {bool waitForSync,
      bool returnNew,
      bool returnOld,
      bool silent,
      bool overwrite,
      bool ignoreRevs,
      bool mergeObjects,
      bool keepNull}) {
    var formatedUrl = '$url?';
    if (waitForSync != null && waitForSync) {
      formatedUrl += 'waitForSync=true&';
    }
    if (returnNew != null && returnNew) {
      formatedUrl += 'returnNew=true&';
    }
    if (returnOld != null && returnOld) {
      formatedUrl += 'returnOld=true&';
    }
    if (silent != null && silent) {
      formatedUrl += 'silent=true&';
    }
    if (overwrite != null && overwrite) {
      formatedUrl += 'overwrite=true&';
    }
    if (ignoreRevs != null && ignoreRevs) {
      formatedUrl += 'ignoreRevs=true&';
    }
    if (mergeObjects != null && mergeObjects) {
      formatedUrl += 'mergeObjects=true&';
    }
    if (keepNull != null && keepNull) {
      formatedUrl += 'keepNull=true&';
    }
    formatedUrl = formatedUrl.substring(0, formatedUrl.length - 1);
    return formatedUrl;
  }

  /// Deletes a document
  void delete() async {
    var request = collection.client
        .prepareRequest('/_api/document/${id}', methode: 'delete');
    await collection.client.send(request);
  }

  /// Returns head
  Future<Map<String, dynamic>> head() async {
    Map<String, dynamic> res;
    try {
      var request = collection.client
          .prepareRequest('/_api/document/${id}', methode: 'head');
      res = await collection.client.exec(request);
    } catch (e) {
      print(e);
    }
    return res;
  }

  /// Returns all documents of a colleciton
  Future<Map<String, dynamic>> allDocuments(String col, {String type}) async {
    Map<String, dynamic> res;
    try {
      var request = collection.client
          .prepareRequest('/_api/simple/all-keys', methode: 'put');
      request.body = type == null
          ? '{"collection": $col}'
          : '{"collection": $col, "type": $type}';
      res = await collection.client.exec(request);
    } catch (e) {
      print(e);
    }
    return res;
  }

  /// Replaces a document
  Future<Document> replace(Map<String, dynamic> data,
      {bool waitForSync,
      bool returnNew,
      bool returnOld,
      bool silent,
      bool overwrite}) async {
    data.remove('_id');
    data.remove('_key');
    data.remove('_rev');
    var d = jsonEncode(data);
    Request request;
    var url = formatUrl('/_api/document/${id}',
        waitForSync: waitForSync,
        returnNew: returnNew,
        returnOld: returnOld,
        silent: silent,
        overwrite: overwrite);
    request = collection.client.prepareRequest(url, methode: 'put');
    request.body = d;
    await collection.client.exec(request);
    this.data = data;
    //this.rev = doc.remove('_rev');
    return this;
  }

  /// Replaces all documents
  Future<Document> replaceAllDocuments(Map<String, dynamic> data, String col,
      {bool waitForSync,
      bool returnNew,
      bool returnOld,
      bool ignoreRevs}) async {
    data.remove('_id');
    data.remove('_key');
    data.remove('_rev');
    var d = jsonEncode(data);
    Request request;
    var url = formatUrl('/_api/document/${col}',
        waitForSync: waitForSync,
        returnNew: returnNew,
        returnOld: returnOld,
        ignoreRevs: ignoreRevs);
    request = collection.client.prepareRequest(url, methode: 'put');
    request.body = d;
    await collection.client.exec(request);
    this.data = data;
    //this.rev = doc.remove('_rev');
    return this;
  }

  /// Updates all documents
  Future<Document> updateAllDocuments(Map<String, dynamic> data, String col,
      {bool waitForSync,
      bool returnNew,
      bool returnOld,
      bool ignoreRevs,
      bool mergeObjects,
      bool keepNull}) async {
    data.remove('_id');
    data.remove('_key');
    data.remove('_rev');
    var d = jsonEncode(data);
    Request request;
    var url = formatUrl('/_api/document/${col}',
        waitForSync: waitForSync,
        returnNew: returnNew,
        returnOld: returnOld,
        ignoreRevs: ignoreRevs,
        mergeObjects: mergeObjects,
        keepNull: keepNull);
    request = collection.client.prepareRequest(url, methode: 'patch');
    request.body = d;
    await collection.client.exec(request);
    this.data = data;
    //this.rev = doc.remove('_rev');
    return this;
  }
}
