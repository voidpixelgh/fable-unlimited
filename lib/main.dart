import 'package:flutter/material.dart';
import 'api_service.dart';
import 'writers_page.dart';
import 'story_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final apiService = ApiService();

  MyApp({super.key});

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Select Language')),
        body: Center(
          child: FutureBuilder<List<String>>(
            future: apiService.fetchLanguages(), // your async function
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
                    String language = snapshot.data![index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                StoryPage(language: language, writer: "Roald Dahl", topic: "Animal Adventures",),
                                // WritersPage(language: language),
                          ),
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        color: color,
                        child: Text(language,
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
      ),
    );
  }
}
