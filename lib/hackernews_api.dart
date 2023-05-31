import 'dart:convert';
import 'package:http/http.dart' as http;

class HackerNewsAPI {
  Future<List<dynamic>> fetchStories(StoryType storyType) async {
    final response = await http.get(
      Uri.parse('https://hacker-news.firebaseio.com/v0/${storyType.apiPath}.json'),
    );
    final List<dynamic> storyIds = jsonDecode(response.body);

    final List<dynamic> stories = await Future.wait(
      storyIds.take(20).map((id) => fetchStory(id)),
    );

    return stories;
  }

  Future<dynamic> fetchStory(int id) async {
    final response = await http.get(Uri.parse('https://hacker-news.firebaseio.com/v0/item/$id.json'));
    return jsonDecode(response.body);
  }
}

enum StoryType {
  topStories,
  bestStories,
}

extension StoryTypeExtension on StoryType {
  String get apiPath {
    switch (this) {
      case StoryType.topStories:
        return 'topstories';
      case StoryType.bestStories:
        return 'beststories';
    }
  }
}
