import 'package:http/http.dart' show Client;
import 'dart:convert';
import '../models/item_models.dart';
import 'dart:async';
import 'repository.dart';


class NewsApiProvider implements Source{
  Client client = Client();

  Future<List<int>> fetchTopItems () async {
    // ' http' no trailing whitespaces should be present 
    final response = await client.get('https://hacker-news.firebaseio.com/v0/topstories.json');
    final ids = json.decode(response.body);
    return ids.cast<int>();
  }

  Future<ItemModel> fetchItems(int id) async {
    final response = await client.get('https://hacker-news.firebaseio.com/v0/item/$id.json');
    final parsedJson = json.decode(response.body);
    return ItemModel.fromJson(parsedJson);
  }
}