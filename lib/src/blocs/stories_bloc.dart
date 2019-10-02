import 'package:rxdart/rxdart.dart';
import '../models/item_models.dart';
import '../resources/repository.dart';

class StoriesBloc {
  //This is similar to the streamcontroller. 
  //As we are dealing with the top id's for the top news page
  final _repository = new Repository();
  final _topIds = PublishSubject<List<int>>();
  final _itemsOutput = BehaviorSubject<Map<int, Future<ItemModel>>>();
  final _itemsFetcher = PublishSubject<int>();

  //Getters to the stream. 
  //Anyone who want to access the stream can use the getter function
  Observable<List<int>>  get topIds => _topIds.stream;
  Observable<Map<int, Future<ItemModel>>> get items => _itemsOutput.stream; 
  // Observable<Map<int,Future<ItemModel>>> get item;

   //Getter to Sinks
  Function(int) get fetchItem => _itemsFetcher.sink.add;

  StoriesBloc() {
    /*
    The transform is not applied to our current stream _items, rather the code returns a new stream
    with the transform property applied to it. We are going to create a reference variable that will hold
    the reference to the modified item stream.
    reference: 
    Observable<Map<int, Future<ItemModel>>> items = ;
    _items.stream.transform(_itemsTransformer());
    */
    _itemsFetcher.stream.transform(_itemsTransformer()).pipe(_itemsOutput); 
  }

 
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
    _itemsOutput.close();
    _itemsFetcher.close();
  }
}