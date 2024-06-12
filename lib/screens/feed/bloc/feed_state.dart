part of 'feed_bloc.dart';

sealed class FeedState {
  const FeedState({required this.state});
  final List<FeedModel> state;
}

final class FeedInitial extends FeedState {
  const FeedInitial({required super.state});
}

class InitialState extends FeedState {
  InitialState({required super.state});
}

class LoadedState extends FeedState {
  LoadedState({required super.state});
}
