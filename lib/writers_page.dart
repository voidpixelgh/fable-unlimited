import 'package:flutter/material.dart';
import 'api_service.dart';
import 'topics_page.dart';

var titleTranslations = {
  "English": "Selet the writer",
  "Spanish": "Selecciona al escritor",
  "German": "Wählen Sie den Schriftsteller aus",
  "French": "Sélectionnez l'écrivai"
};

class WritersPage extends StatelessWidget {
  final String language;
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

  WritersPage({super.key, required this.language});

  /* @override */
  @override
  Widget build(BuildContext context) {
    String? title = titleTranslations[language];

    return Scaffold(
      appBar: AppBar(title: Text(title!)),
      body: Center(
        child: FutureBuilder<List<String>>(
          future: apiService.fetchWriters(language), // your async function
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
                  String writer = snapshot.data![index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TopicsPage(language: language, writer: writer),
                        ),
                      );
                    },
                    child: Container(
                      alignment: Alignment.center,
                      color: color,
                      child: Text(writer,
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
