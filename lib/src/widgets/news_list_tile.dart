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
          return buidTileLoading();
        }

        return FutureBuilder(
          //Get the specific future from the cache map of itemId
          future: snapshot.data[itemId],
          //We have already resolved the future above so our AsyncSnapshot only contains an
          //ItemModel
          builder: (context,AsyncSnapshot<ItemModel> itemSnapshot) {
            if(!itemSnapshot.hasData) {
              return buidTileLoading();
            }
            return buidTile(itemSnapshot.data,context);
          },
        );
      },
    );
  }

  Widget buidTile(ItemModel item, BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () {
          print('${item.id} was tapped');
          Navigator.pushNamed(context, '/${item.id}');
        },
        title: Text(item.title,
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold ),
        ),
        subtitle: Text("${item.score} votes"),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.comment, color: Colors.black),
            Text("${item.descendants}")
        ],),
      ),
      elevation: 10.0,
      margin: EdgeInsets.all(10.0)
    ); 
  }

   Widget buidTileLoading() {
    return Card(
      child: ListTile(
        title: Container(
          height: 10.0,
          width: 40.0,
          color: Colors.grey[300],
        ),
        subtitle: Container(
          height: 7.0,
          width: 20.0,
          color: Colors.grey[300],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
          height: 10.0,
          width: 10.0,
          color: Colors.grey[300],
        ),
            Container(
          height: 5.0,
          width: 10.0,
          color: Colors.grey[300],
        )
        ],),
      ),
      elevation: 10.0,
      margin: EdgeInsets.all(10.0)
    ); 
  }
} 