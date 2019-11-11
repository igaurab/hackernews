import 'package:hackernews/src/resources/news_api_provider.dart';
import 'dart:convert';
import 'package:http/http.dart' show Client;
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';

void main() {
  test("FetchTopId's returns a list of ids", () async{
    final newsApi = NewsApiProvider();

    newsApi.client = MockClient((request) async{
      return Response(json.encode([1,2,3,4,5]),200);
    });

    final ids = await newsApi.fetchTopItems();
    expect(ids, [1,2,3,4,5]);
  });



  test('Fetch Individual Item', () async{
    final newsApi = NewsApiProvider();
    
    newsApi.client = MockClient( (request) async{
      final jsonMap = {'id':120};
      return Response(json.encode(jsonMap),200);
    });

    final item = await newsApi.fetchItems(120);

    expect(item.id, 120 );
  });
}
