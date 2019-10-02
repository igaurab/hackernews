import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'dart:async';
import '../models/item_models.dart';
import 'repository.dart';

class NewsDbProvider implements Source, Cache{
  Database db;

  NewsDbProvider() {
    init();
  }

  void init() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentDirectory.path, "items.db");
    
    //It will try to create a database if doesn't exits at the give path
    //or use the database if it exists.
    db = await openDatabase(
      path,
      version: 1,
      //This callback is called only if the person has opened our application 
      //for the very first time
      /*
        newDb is the reference to the database that we are going to create. Since db is not yet assigned
       */
      onCreate: (Database newDb, int version) {
        newDb.execute("""
          CREATE TABLE Items (
            id INTEGER PRIMARY KEY,
            type TEXT,
            time INTEGER,
            text TEXT,
            parent INTEGER,
            kids BLOB,
            dead INTEGER,
            deleted INTEGER,
            url TEXT,
            score INTEGER,
            title TEXT,
            descendants INTEGER
          )
        """);
      }
    );
  }

  /*
    where: id = ?
    whereArgs defines the arguments that will be replaced instead of ?
  */
  Future<ItemModel> fetchItems(int id) async {
    final maps = await db.query(
      "Items",
      columns: null,
      where: "id = ?",
      whereArgs: [id],
    );

    if(maps.length > 0) {
      return ItemModel.fromDb(maps.first);
    }
    return null;
  }

  Future<int> addItem(ItemModel itemModel) {
    return db.insert("Items",
     itemModel.toMapForDb(),
     conflictAlgorithm: ConflictAlgorithm.ignore
     );
  }

  Future<List<int>> fetchTopItems(){
    //TODO: Store and fetchTopIds
    return null;
  }

}

final newsDbProvider = new NewsDbProvider();