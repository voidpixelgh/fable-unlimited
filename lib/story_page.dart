import 'package:flutter/material.dart';
import 'api_service.dart';
import 'package:logger/logger.dart';

class Story {
  String title;
  String content;

  Story(this.title, this.content);
}

class StoryPage extends StatefulWidget  {
  final String language;
  final String writer;
  final String topic;

  /* final apiService = ApiService(); */

  const StoryPage({super.key, required this.language, required this.writer , required this.topic});

  @override
  // ignore: library_private_types_in_public_api
  _StoryPageState createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  String pageTitle = "Loading..."; // Initial title
  String fullText = ""; // Initial story content

  final apiService = ApiService();

  @override
  void initState() {
    super.initState();
    apiService.fetchStory(widget.language, widget.writer, widget.topic).then((story) {
      setState(() {
        logger.i(story);
        pageTitle = story["title"]!;
        fullText = story["story"]!;
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue, width: 4),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            fullText,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }


}