import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_project/data/repositories/api/feed_api.dart';
import 'package:test_project/screens/feed/bloc/feed_model.dart';

part 'feed_event.dart';
part 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  FeedBloc({required this.feedApi}) : super(const FeedInitial(state: [])) {
    on<InitEvent>(_onInitEvent);
    on<LoadItemsEvent>(_onLoadItemsEvent);
  }
  final FeedApi feedApi;

  void _onLoadItemsEvent(LoadItemsEvent event, Emitter emit) async {
    final feedDataList = await feedApi.feedPagination(event.from);
    final feedList =
        feedDataList.map((e) => FeedModel.fromDataModel(e)).toList();
    state.state.addAll(feedList);
    emit(LoadedState(state: state.state));
  }

  void _onInitEvent(InitEvent event, Emitter emitter) async {
    final feedDataList = await feedApi.feedPagination(0);
    final feedList =
        feedDataList.map((e) => FeedModel.fromDataModel(e)).toList();
    emitter(InitialState(state: feedList));
  }
}
