import 'package:test_project/data/repositories/api/feed_model.dart';

class FeedModel {
  FeedModel({
    required this.caption,
    required this.interests,
    required this.isAlert,
    required this.creatDuration,
    required this.user,
    required this.media,
  });
  final bool isAlert;
  final String caption;
  final String creatDuration;
  final List<MediaModel> media;
  final UserModel user;
  final List<String> interests;

  static FeedModel fromDataModel(FeedDataModel feedDataModel) {
    final imageMedia = feedDataModel.imagesList
        .map((e) => MediaModel(asset: e, isVideo: false));
    final videoMedia = feedDataModel.imagesList
        .map((e) => MediaModel(asset: e, isVideo: true));
    return FeedModel(
        caption: feedDataModel.caption,
        interests: feedDataModel.interests,
        isAlert: feedDataModel.isAlert,
        creatDuration: _createDuration(feedDataModel.updatedAt),
        user: UserModel(
            image: feedDataModel.user.image,
            userName:
                '${feedDataModel.user.firstName} ${feedDataModel.user.firstName[0]}.'),
        media: [...imageMedia, ...videoMedia]);
  }

  static String _createDuration(DateTime createDate) {
    final duration = DateTime.now().difference(createDate);
    if (duration.inHours != 0) {
      return '${duration.inHours} hours ago';
    }
    if (duration.inMinutes != 0) {
      return '${duration.inMinutes} minits ago';
    }
    return '${duration.inSeconds} seconds ago';
  }
}

class MediaModel {
  MediaModel({required this.asset, required this.isVideo});
  final bool isVideo;
  final String asset;
}

class UserModel {
  UserModel({required this.userName, required this.image});
  final String userName;
  final String? image;
}
