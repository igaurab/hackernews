import 'package:flutter/material.dart';
import 'screens/newslist.dart';
import 'screens/news_detail.dart';
import './blocs/stories_provider.dart';
import './blocs/comments_bloc_provider.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return CommentsBlocProvider(
      child:  StoriesProvider(
      child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HackerNews',
      onGenerateRoute: routes,
      )
      ),
    );

  }

  Route routes(RouteSettings settings) {
    //Different MaterialPageRoute for each new Route you want to generate.
    //You can use switch statement on settings.name
    if(settings.name == '/') {
      return MaterialPageRoute(
        builder: (context) {
          return NewsList();
        },
      );
    }else{
      return MaterialPageRoute(
        builder: (context) {
          final commentsBloc = CommentsBlocProvider.of(context);
          final int itemId = int.parse(settings.name.replaceFirst('/', ''));

          //Starts the recursive data fetching process
          commentsBloc.fetchItemsWithComments(itemId);

          return NewsDetail(
            itemId: itemId,
          );
        },
      );
    }
    
  }
}