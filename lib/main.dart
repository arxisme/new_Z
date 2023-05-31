import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
void main() {
  runApp(const HackerNewsApp());
}

class HackerNewsApp extends StatelessWidget {
  const HackerNewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'neW_Z',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> _stories = [];
  StoryType _selectedStoryType = StoryType.topStories;

  @override
  void initState() {
    super.initState();
    fetchStories();
  }

  Future<void> fetchStories() async {
    final api = HackerNewsAPI();
    final stories = await api.fetchStories(_selectedStoryType);

    setState(() {
      _stories = stories;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('new_Z'),
        actions: [
          DropdownButton<StoryType>(
            value: _selectedStoryType,
            items: const [
              DropdownMenuItem(
                value: StoryType.topStories,
                child: Text('Top Stories'),
              ),
              DropdownMenuItem(
                value: StoryType.bestStories,
                child: Text('Best Stories'),
              ),
            ],
            onChanged: (StoryType? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedStoryType = newValue;
                });
                fetchStories();
              }
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _stories.length,
        itemBuilder: (BuildContext context, int index) {
          final story = _stories[index];
          return StoryTile(
            story: story,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) =>
                      StoryWebView(url: story['url']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class StoryTile extends StatelessWidget {
  final dynamic story;
  final VoidCallback onTap;

  const StoryTile({super.key, required this.story, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          title: Text(
            story['title'],
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            'Author: ${story['by']}   Score: ${story['score']}.',
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ),
    );
  }
}



class StoryWebView extends StatelessWidget {
  final String url;

  const StoryWebView({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
      ),
      body: WebView(
        initialUrl: url,
      ),
    );
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
