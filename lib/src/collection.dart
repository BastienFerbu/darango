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

  Collection(this.name);
}