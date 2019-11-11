# Darango
A Dart driver for ArangoDB

This package based on [http][] and [ArangoDB API][] allows to communicate with your 
ArangoDB database using Dart. I still work on it on my free time but feel free to 
help (especially on the proper way of coding).

[http]: https://github.com/dart-lang/http
[ArangoDB API]: https://www.arangodb.com/docs/stable/http/

## Using

You first need to create a database and connect to it.

```dart
import 'package:darango/darango.dart';

String url = "http://127.0.0.1:8529";
String database_name = "";
String username = "";
String password = "";

Database database = Database(url);
await database.connect(database_name, username, password);
```

After that you can make CRUD operations on documents.

```dart 
Collection usersCollection = await database.collection("users");

if(usersCollection != null){
    // Create
    Map<String, dynamic> user = {"lastName":"Toto", "FirstName":"Titi"};
    Document doc = await usersCollection.document().add(user);
    // Read
    doc = await usersCollection.document().get(doc.id);
    // Update
    Map<String, dynamic> user2 = {"_key":doc.key,"_id":doc.id,"_rev":doc.rev,
        "lastName":"Toto","FirstName":"Titi", "email": "toto@gmail.com"};
    doc = await usersCollection.document().update(user2);
    // Delete
    await usersCollection.document().delete(doc.id);
}
```

You can also make AQL query.

```dart 
Aql aql = database.aql();
String query = """
    FOR c IN users
    RETURN c
""";

dynamic result = await aql.run(query);
print(result["result"]);
```

***
## TODO
* Transactions
* Graph
* CRUD on collections
* ...
