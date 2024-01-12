import 'package:flutter/material.dart';
import 'api_service.dart';
import 'story_page.dart';

var titleTranslations = {
  "English": "Selet the topic",
  "Spanish": "Selecciona el tema",
  "German": "Wählen Sie das Thema aus",
  "French": "Sélectionnez le suje"
};

class TopicsPage extends StatelessWidget {
  final String language;
  final String writer;
  final apiService = ApiService();

  final List<Color> colors = [
    Colors.lightBlueAccent,
    Colors.lightGreen,
    Colors.amber,
    Colors.pinkAccent,
    Colors.orange,
    Colors.purpleAccent,
    Colors.tealAccent,
    Colors.indigoAccent,
    Colors.deepOrangeAccent,
    // Add more colors as needed
  ];

  TopicsPage({super.key, required this.language, required this.writer});

  @override
  Widget build(BuildContext context) {
    String? title = titleTranslations[language];

    return Scaffold(
      appBar: AppBar(title: Text(title!)),
      body: Center(
        child: FutureBuilder<List<String>>(
          future: apiService.fetchTopics(language), // your async function
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(); // Show loader while waiting for data
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}'); // Show error if any
            } else if (snapshot.hasData) {
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Color color = colors[index % colors.length];
                  String topic = snapshot.data![index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StoryPage(language: language, writer: writer, topic: topic),
                        ),
                      );
                    },
                    child: Container(
                      alignment: Alignment.center,
                      color: color,
                      child: Text(topic,
                          style: const TextStyle(color: Colors.black)),
                    ),
                  );
                },
              );
            } else {
              return const Center(child: Text('No languages supported'));
            }
          },
        ),
      ),
    );
  }
}
