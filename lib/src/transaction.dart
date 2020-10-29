part of darango;

class Transaction {
  ArangoClient client;
  Transaction(this.client);

  /// Executes a transaction
  Future<dynamic> executeTransaction(dynamic collections, String action,
      {String params,
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
    } catch (e) {
      print(e);
    }
    return doc['result'];
  }

  /// Begins a transaction
  Future<Map<dynamic, dynamic>> begin(dynamic collections,
      {bool waitForSync,
      bool allowImplicit,
      int lockTimeout,
      int maxTransactionSize}) async {
    var request =
        client.prepareRequest('/_api/transaction/begin', methode: 'post');
    request.body = collections;
    Map<dynamic, dynamic> doc;
    try {
      doc = await client.exec(request);
    } catch (e) {
      print(e);
    }
    return doc['result']; // return id and status of the transaction
  }

  /// Commits a transaction
  Future<Map<dynamic, dynamic>> commit(int id) async {
    var request =
        client.prepareRequest('/_api/transaction/$id', methode: 'put');
    Map<dynamic, dynamic> doc;
    try {
      doc = await client.exec(request);
    } catch (e) {
      print(e);
    }
    return doc['result']; // return id and status of the transaction
  }

  /// Aborts a transaction
  Future<Map<dynamic, dynamic>> abort(int id) async {
    var request =
        client.prepareRequest('/_api/transaction/$id', methode: 'delete');
    Map<dynamic, dynamic> doc;
    try {
      doc = await client.exec(request);
    } catch (e) {
      print(e);
    }
    return doc['result']; // return id and status of the transaction
  }
}
