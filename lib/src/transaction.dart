part of darango;

class Transaction {
  ArangoClient client;
  Transaction(this.client);

  Future<dynamic> execute(dynamic collections, String action, 
    {String params, bool waitForSync = true, bool allowImplicit = true, 
    int lockTimeout = 0, int maxTransactionSize = 0}) async{
    Request request = client.prepareRequest("/_api/transaction", methode: "post");
    request.body = jsonEncode({
      "allowImplicit": allowImplicit,
      "lockTimeout": lockTimeout,
      "maxTransactionSize": maxTransactionSize,
      "params": params,
      "waitForSync": waitForSync,
      "collections" : collections, 
      "action" : action
    });
    Map<dynamic, dynamic> doc;
    try {
      doc = await client.exec(request);
    } catch (e) {
    }
    return doc["result"];
  }

  Future<Map<dynamic, dynamic>> begin(dynamic collections, {bool waitForSync, bool allowImplicit, int lockTimeout, int maxTransactionSize}) async{
    Request request = client.prepareRequest("/_api/transaction/begin", methode: "post");
    request.body = collections;
    Map<dynamic, dynamic> doc;
    try {
      doc = await client.exec(request);
    } catch (e) {
      print(e);
    }
    return doc["result"]; // return id and status of the transaction
  }

  Future<Map<dynamic, dynamic>> commit(int id) async{
    Request request = client.prepareRequest("/_api/transaction/$id", methode: "put");
    Map<dynamic, dynamic> doc;
    try {
      doc = await client.exec(request);
    } catch (e) {
      print(e);
    }
    return doc["result"]; // return id and status of the transaction
  }

  Future<Map<dynamic, dynamic>> abort(int id) async{
    Request request = client.prepareRequest("/_api/transaction/$id", methode: "delete");
    Map<dynamic, dynamic> doc;
    try {
      doc = await client.exec(request);
    } catch (e) {
      print(e);
    }
    return doc["result"]; // return id and status of the transaction
  }
}