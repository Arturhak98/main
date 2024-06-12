part of 'feed_bloc.dart';

sealed class FeedEvent {}

class InitEvent extends FeedEvent {}

class LoadItemsEvent extends FeedEvent {
  LoadItemsEvent({required this.from});
  final int from;
}
