class FeedDataModel {
  FeedDataModel({
    required this.caption,
    required this.imagesList,
    required this.interests,
    required this.isAlert,
    required this.updatedAt,
    required this.user,
    required this.videosList,
  });
  final bool isAlert;
  final String caption;
  final DateTime updatedAt;
  final List<String> imagesList;
  final List<String> videosList;
  final UserDataModel user;
  final List<String> interests;

  static FeedDataModel fromJson(Map<String, dynamic> json) {
    final imageList =
        (json['images'] as List).map((e) => e['image'] as String).toList();
    final videosList = (json['videos'] as List)
        .map((e) => e['videoThumbnail'] as String)
        .toList();
    final interests =
        (json['interests'] as List).map((e) => e['title'] as String).toList();

    return FeedDataModel(
        caption: json['caption'],
        imagesList: imageList,
        interests: interests,
        isAlert: json['isAlert'],
        updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updatedAt']),
        user: UserDataModel.fromJson(json['customer']),
        videosList: videosList);
  }
}

class UserDataModel {
  UserDataModel(
      {required this.firstName, required this.image, required this.lastName});
  final String firstName;
  final String lastName;
  final String? image;

  static UserDataModel fromJson(Map<String, dynamic> json) {
    return UserDataModel(
        firstName: json['firstName'],
        image: json['image'],
        lastName: json['lastName']);
  }
}
