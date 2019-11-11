import "package:flutter/material.dart";
import "../blocs/comments_bloc_provider.dart";
import 'dart:async';
import "../models/item_models.dart";

class NewsDetail extends StatelessWidget {

  final int itemId;
  NewsDetail({this.itemId});

  @override
  Widget build(BuildContext context) {
    final bloc = CommentsBlocProvider.of(context);
    return(
      Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: Text("Detail of $itemId", style: TextStyle(color: Colors.black),),
          centerTitle: true,
          leading: Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
        body: buildBody(bloc),
    ));
  }

  Widget buildBody(CommentsBloc bloc) {
    return StreamBuilder(
      stream: bloc.itemWithComments,
      builder: (context,AsyncSnapshot<Map<int, Future<ItemModel>>> snapshot) {
        if(!snapshot.hasData) {
          return CircularProgressIndicator();
        }

        final itemFuture = snapshot.data[itemId];

        return FutureBuilder(
          future: itemFuture,
          builder: (context,AsyncSnapshot<ItemModel> itemSnapshot) {
            if(!itemSnapshot.hasData) {
              return CircularProgressIndicator();
            }

            return Text(itemSnapshot.data.title);
          },
        );
      },
    );
  }
}