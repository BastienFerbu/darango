part of darango;

class Transaction {
  ArangoClient client;
  Transaction(this.client);

  /// Executes a transaction
  Future<Map<dynamic, dynamic>?> executeTransaction(dynamic collections, String action,
      {String? params,
      bool waitForSync = true,
      bool allowImplicit = true,
      int lockTimeout = 0,
      int maxTransactionSize = 0}) async {
    var request = client.prepareRequest('/_api/transaction', methode: 'post');
    request.body = jsonEncode({
      'allowImplicit': allowImplicit,
      'lockTimeout': lockTimeout,
      'maxTransactionSize': maxTransactionSize,
      'params': params,
      'waitForSync': waitForSync,
      'collections': collections,
      'action': action
    });
    Map<dynamic, dynamic> doc;
    try {
      doc = await client.exec(request);
      return doc['result'];
    } catch (e) {
      print(e);
    }
    return null;
  }

  /// Begins a transaction
  Future<Map<dynamic, dynamic>?> begin(dynamic collections) async {
    var request =
        client.prepareRequest('/_api/transaction/begin', methode: 'post');
    request.body = collections;
    Map<dynamic, dynamic> doc;
    try {
      doc = await client.exec(request);
      return doc['result']; // return id and status of the transaction
    } catch (e) {
      print(e);
    }
    return null;
  }

  /// Commits a transaction
  Future<Map<dynamic, dynamic>?> commit(int id) async {
    var request =
        client.prepareRequest('/_api/transaction/$id', methode: 'put');
    Map<dynamic, dynamic> doc;
    try {
      doc = await client.exec(request);
      return doc['result']; // return id and status of the transaction
    } catch (e) {
      print(e);
    }
    return null;
  }

  /// Aborts a transaction
  Future<Map<dynamic, dynamic>?> abort(int id) async {
    var request =
        client.prepareRequest('/_api/transaction/$id', methode: 'delete');
    Map<dynamic, dynamic> doc;
    try {
      doc = await client.exec(request);
      return doc['result']; // return id and status of the transaction
    } catch (e) {
      print(e);
    }
    return null;
  }
}
