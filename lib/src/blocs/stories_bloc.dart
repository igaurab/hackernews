import 'package:rxdart/rxdart.dart';
import '../models/item_models.dart';
import '../resources/repository.dart';

class StoriesBloc {
  //This is similar to the streamcontroller. 
  //As we are dealing with the top id's for the top news page
  final _repository = new Repository();
  final _topIds = PublishSubject<List<int>>();
  final _itemsOutput = BehaviorSubject<Map<int,Future<ItemModel>>>();
  final _itemsFetcher  = PublishSubject<int>();
  //Getters to the stream. 
  //Anyone who want to access the stream can use the getter function
  Observable<List<int>>  get topIds => _topIds.stream;
  Observable<Map<int, Future<ItemModel>>> get items => _itemsOutput.stream;
  Function(int) get fetchItem => _itemsFetcher.sink.add;

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
    ItemsFetcher takes the input id of the items we want to fetch
    and then outputs the cache containing of a map, which maps the item id to the
    itemModel
  */
    _itemsFetcher.stream.transform(_itemsTransformer()).pipe(_itemsOutput);
  }

  //Getter to Sinks

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
    _itemsFetcher.close();
    _itemsOutput.close();
  }
}