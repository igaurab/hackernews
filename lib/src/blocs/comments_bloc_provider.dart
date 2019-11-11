import "package:flutter/material.dart";
import "comments_bloc.dart";
export "comments_bloc.dart";

class CommentsBlocProvider extends InheritedWidget{

  final CommentsBloc bloc;
  CommentsBlocProvider({Key key, Widget child})
    : bloc = CommentsBloc(),
      super(key: key, child:child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static CommentsBloc of (BuildContext context) {
     return (context.inheritFromWidgetOfExactType(CommentsBlocProvider)
     as CommentsBlocProvider)
     .bloc;
  }

}