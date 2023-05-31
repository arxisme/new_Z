import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StoryWebView extends StatelessWidget {
  final String url;

  const StoryWebView({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: WebView(
        initialUrl: url,
      ),
    );
  }
}
