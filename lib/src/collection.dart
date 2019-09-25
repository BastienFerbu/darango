part of darango;

class Collection {
  String distributeShardsLike;
  bool doCompact;
  int indexBuckets;
  bool isSystem;
  bool isVolatile;
  int journalSize;
  Map<String,dynamic> keyOptions;
  String name;
  int numberOfShards;
  int replicationFactor;
  String shardKeys;
  String shardingStrategy;
  String smartJoinAttribute;
  int type;
  bool waitForSync; 
  ArangoClient client;

  Collection(this.name, this.client);


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