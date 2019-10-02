import 'package:flutter/material.dart';
import '../models/item_models.dart';
import '../blocs/stories_provider.dart';
import 'dart:async';

class NewsListTitle extends StatelessWidget {
  final int itemId;
  NewsListTitle({this.itemId});

  @override
  Widget build(BuildContext context) {
    final bloc = StoriesProvider.of(context);
    
    return StreamBuilder(
      stream: bloc.items,
      builder: (context,AsyncSnapshot<Map<int, Future<ItemModel>>> snapshot) {
        if(!snapshot.hasData) {
          return Text('Stream Still Loading...');
        }

        return FutureBuilder(
          //Get the specific future from the cache map of itemId
          future: snapshot.data[itemId],
          //We have already resolved the future above so our AsyncSnapshot only contains an
          //ItemModel
          builder: (context,AsyncSnapshot<ItemModel> itemSnapshot) {
            if(!itemSnapshot.hasData) {
              return Text("Still lodaing $itemId");
            }
            return Text(itemSnapshot.data.title);
          },
        );
      },
    );
  }
} 