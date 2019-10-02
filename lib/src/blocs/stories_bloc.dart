import 'package:rxdart/rxdart.dart';
import '../models/item_models.dart';
import '../resources/repository.dart';

class StoriesBloc {
  //This is similar to the streamcontroller. 
  //As we are dealing with the top id's for the top news page
  final _repository = new Repository();
  final _topIds = PublishSubject<List<int>>();
  final _items = BehaviorSubject<int>();

  //Getters to the stream. 
  //Anyone who want to access the stream can use the getter function
  Observable<List<int>>  get topIds => _topIds.stream;
  Observable<Map<int, Future<ItemModel>>> items;
  /*
  Problem:
  This is not the best way to do it.
  Every widget that tries to access the stream through this getter function
  ends up creating thier own version of ScanStreamTransformer() object
  and every widget thus has thier own cache. This creates duplicates.
  Thus we would want to apply the transformer only one time to our stream.
  Solution: 
  We make the use of Constructor to transform this stream only once.
  code: get items => _items.stream.transform(_itemsTransformer());
  */
  StoriesBloc() {
    /*
    The transform is not applied to our current stream _items, rather the code returns a new stream
    with the transform property applied to it. We are going to create a reference variable that will hold
    the reference to the modified item stream.
    reference: 
    Observable<Map<int, Future<ItemModel>>> items = ;
    _items.stream.transform(_itemsTransformer());
    */
    items = _items.stream.transform(_itemsTransformer());
  }

  //Getter to Sinks
  Function(int) get fetchItem => _items.sink.add;

  fetchTopIds() async{
    final ids = await _repository.fetchTopItems();
    _topIds.sink.add(ids);
  }

  _itemsTransformer() {
    return ScanStreamTransformer(
      (Map<int, Future<ItemModel>> cache, int id, _) {
        cache[id] = _repository.fetchItems(id);
        return cache;
      },
      <int, Future<ItemModel>> {}
    );
  }
  void dispose() {
    _topIds.close();
    _items.close();
  }
}