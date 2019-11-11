import 'dart:async';
import 'package:rxdart/rxdart.dart';
import '../models/item_models.dart';
import '../resources/repository.dart';

class CommentsBloc {
  
   final Repository _repository = new Repository();
   final _commentsFetcher = PublishSubject<int>();
   final _commentsOutput = BehaviorSubject<Map<int,Future<ItemModel>>>();

  CommentsBloc() {
    _commentsFetcher.stream.transform(_commentsTransformer()).pipe(_commentsOutput);
  }
  //Stream Getters
  Observable<Map<int, Future<ItemModel>>> get itemWithComments => _commentsOutput.stream;

  //Sink
  Function(int) get fetchItemsWithComments => _commentsFetcher.sink.add;
  

  _commentsTransformer() {
    //It maintains a cache map
    return ScanStreamTransformer<int, Map<int, Future<ItemModel>>>(
      (cache, int id, index) {
        print(index);
        cache[id] = _repository.fetchItems(id);
        cache[id].then((ItemModel item) {
          item.kids.forEach((kidId) {
            return fetchItemsWithComments(kidId);
          }); 
        });
      },
      <int,Future<ItemModel>> {}
    );
  }

   void dispose(){
     _commentsFetcher.close();
     _commentsOutput.close();
   }
}