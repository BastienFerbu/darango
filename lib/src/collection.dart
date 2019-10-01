part of darango;

class Collection {
  final String name;
  final String id;
  final bool isSystem;
  final int type;
  final int status;
  final String globallyUniqueId;
  ArangoClient client;

  Collection(this.name, this.id, this.isSystem, this.type, this.status, this.globallyUniqueId, this.client);


  Future<String> infos() async {
    Request request = client.prepareRequest("/_api/collection/"+this.name);
    StreamedResponse current = await client.send(request);
    String res = await current.stream.bytesToString();
    return res;
  }

  Document document(){
    return Document(this);
  }
}