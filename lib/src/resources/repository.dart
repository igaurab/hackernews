import 'dart:async';
import 'news_api_provider.dart';
import 'news_db_provider.dart';
import '../models/item_models.dart';

abstract class Source {
  Future<List<int>> fetchTopItems();
  Future<ItemModel> fetchItems(int id);
}

abstract class Cache {
  Future<int> addItem(ItemModel item);
  Future<int> clear();
}

class Repository {
  List<Source> sources = <Source> [
    newsDbProvider,
    NewsApiProvider()
  ];

  List<Cache> caches = <Cache> [
    newsDbProvider
  ];


  //TODO: implement using sources
  //We have just used the ApiProvider to get the data
  Future<List<int>> fetchTopItems(){
    return sources[1].fetchTopItems();
  }

  Future<ItemModel>  fetchItems(int id)async{
    ItemModel item;
    Source source;
    
    for(source in sources) {
      item = await source.fetchItems(id);
      if(item != null) {
        break;
      } 
    }

    for (var cache in caches) {
      cache.addItem(item);
    }
    return item;
  }

  clearCache() async{
    for(var cache in caches) {
      await cache.clear();
    }
  }

}