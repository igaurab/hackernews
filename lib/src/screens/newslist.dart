import 'package:flutter/material.dart';
import 'package:hackernews/src/app.dart';
import '../blocs/stories_provider.dart';
import '../widgets/news_list_tile.dart';
import "../widgets/refresh.dart";


class NewsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = StoriesProvider.of(context);
    bloc.fetchTopIds();
    print("Inside NewsList");
    return Scaffold(
      appBar: AppBar(
        title: Text("Top News",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      
      body: renderTopIds(bloc) ,
    );
  }

  Widget renderTopIds(StoriesBloc bloc) {
    return StreamBuilder(
      stream: bloc.topIds,
      builder: (context,AsyncSnapshot<List<int>> snapshot) {
        if(!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator() ,
          );
        }
        return Refresh(
          child: ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, int index) {
              bloc.fetchItem(snapshot.data[index]);
              return NewsListTitle(itemId: snapshot.data[index],);
            },
            ),
          );
      },
    );
  }
}