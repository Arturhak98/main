import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:test_project/data/repositories/api/feed_model.dart';

abstract class FeedApi {
  Future<List<FeedDataModel>> feedPagination(int from);
}

class FeedApiImpl extends FeedApi {
  @override
  Future<List<FeedDataModel>> feedPagination(int from) async {
    try {
      final request = await http.post(
          Uri.parse('http://18.217.172.204/api/user/posts?from=$from&count=5'));
      if (request.statusCode == 200) {
        final requestData = jsonDecode(request.body) as Map<String, dynamic>;
        final dataList = requestData['result']['data'] as List<dynamic>;
        final feedsList =
            dataList.map((e) => FeedDataModel.fromJson(e)).toList();
        return feedsList;
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }
}
