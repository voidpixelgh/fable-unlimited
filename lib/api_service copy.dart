// In api_service.dart
import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;

var logger = Logger();

class ApiService {
  Future<List<String>> fetchLanguages() async {
    var url = Uri.parse('http://localhost:1234/v1/chat/completions');

    var body = { 
      "messages": [ 
        { "role": "user", "content": "Hello Mistral model, could you please provide me with a list of all the languages you currently support and reply and they are the top 4 spoken languages (discard non european languages) ? I would like the list in JSON format, structured as follows: { \"languages\": [\"Language1\", \"Language2\", ...] }" }
      ], 
      "temperature": 0.9, 
      "max_tokens": -1,
      "stream": false
    };

    try {
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body.trim());
        logger.i(jsonResponse);
        List<dynamic> choices = jsonResponse['choices'];
        logger.i(choices);
        Map<String, dynamic> firstChoice = choices[0];
        logger.i(firstChoice);
        Map<String, dynamic> message = firstChoice['message'];
        logger.i(message);
        String content = message['content'];
        logger.i(content);
        Map<String, dynamic> contentJson = json.decode(content.trim());
        List<dynamic> languages = contentJson['languages'];
        
        return List<String>.from(languages);
      }else {
         logger.e('Something went wrong');
        throw Exception('Failed to load data');
      }
    } catch (error) {
       logger.e('Error: $error');
      // Handle the error
      throw Exception('Failed to load data');
    }
  }

  Future<List<String>> fetchWriters(language) async {
    var url = Uri.parse('http://localhost:1234/v1/chat/completions');

    var body = { 
      "messages": [ 
        { "role": "user", "content": "Hello Mistral model, could you please provide me with a list of best storytelling writers for children in this language: $language. Only the top 10 writers. I would like the list in JSON format, structured as follows: { \"writers\": [\"Pepito Jamones\", \"Juan Calver\", ...] }" }
      ], 
      "temperature": 0.9, 
      "max_tokens": -1,
      "stream": false
    };

    try {
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body.trim());
        logger.i(jsonResponse);
        List<dynamic> choices = jsonResponse['choices'];
        logger.i(choices);
        Map<String, dynamic> firstChoice = choices[0];
        logger.i(firstChoice);
        Map<String, dynamic> message = firstChoice['message'];
        logger.i(message);
        String content = message['content'];
        logger.i(content);
        Map<String, dynamic> contentJson = json.decode(content.trim());
        List<dynamic> writers = contentJson['writers'];
        
        /* logger.i(languages); */

        return List<String>.from(writers);
      }else {
         logger.e('Something went wrong');
        throw Exception('Failed to load data');
      }
    } catch (error) {
       logger.e('Error: $error');
      // Handle the error
      throw Exception('Failed to load data');
    }
  }

  Future<List<String>> fetchTopics(language) async {
    var url = Uri.parse('http://localhost:1234/v1/chat/completions');

    var body = { 
      "messages": [ 
        { "role": "user", "content": "Hello Mistral model, could you please provide me with a list of best storytelling topics for children in this language: $language. Only the top 10 topics. I would like the list in JSON format, structured as follows: { \"topics\": [\"Unicorns\", \"Dragons\", ...] }" }
      ], 
      "temperature": 0.1, 
      "max_tokens": -1,
      "stream": false
    };

    try {
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body.trim());
        logger.i(jsonResponse);
        List<dynamic> choices = jsonResponse['choices'];
        logger.i(choices);
        Map<String, dynamic> firstChoice = choices[0];
        logger.i(firstChoice);
        Map<String, dynamic> message = firstChoice['message'];
        logger.i(message);
        String content = message['content'];
        logger.i(content);
        Map<String, dynamic> contentJson = json.decode(content.trim());
        List<dynamic> topics = contentJson['topics'];

        return List<String>.from(topics);
      }else {
         logger.e('Something went wrong');
        throw Exception('Failed to load data');
      }
    } catch (error) {
       logger.e('Error: $error');
      // Handle the error
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, String>> fetchStory(language, writer, topic) async {
    var url = Uri.parse('http://localhost:1234/v1/chat/completions');

    var body = { 
      "messages": [ 
        { "role": "user", "content": "Hello Mistral, I would like to request a children's story written in $language. The story should be inspired by the writing style of $writer. The central theme of the story should be about $topic. Please ensure that the story is engaging and appropriate for young children, capturing the imaginative and whimsical essence typical of $writer' storytelling. It should be a short story, suitable for a bedtime reading session. This prompt clearly states: 1- The target language for the story ($language). 2- The desired writing style (inspired by $writer). 3. The specific topic of the story ($topic). 4- The intended audience (young children) and the appropriate tone (engaging, imaginative, whimsical). 5- The context or use case of the story (bedtime reading session), which helps in determining the length and complexity of the story. 6- The ending needs to explain the moral of the story. 7- it's a super short story of 20 characters. The output needs to be in json format with schema: { title: \"Title of story\", \"story\": \"...\" }" }
        // { "role": "user", "content": "Hello Mistral, I would like to request a children's story written in $language. The story should be inspired by the writing style of $writer. The central theme of the story should be about $topic. Please ensure that the story is engaging and appropriate for young children, capturing the imaginative and whimsical essence typical of $writer' storytelling. It should be a short story, suitable for a bedtime reading session. This prompt clearly states: 1- The target language for the story ($language). 2- The desired writing style (inspired by $writer). 3. The specific topic of the story ($topic). 4- The intended audience (young children) and the appropriate tone (engaging, imaginative, whimsical). 5- The context or use case of the story (bedtime reading session), which helps in determining the length and complexity of the story. 6- The ending needs to explain the moral of the story. The output needs to be in json format with schema: { title: \"Title of story\", \"story\": \"...\" }" }
      ], 
      "temperature": 0.1, 
      "max_tokens": -1,
      "stream": false
    };

    try {
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body.trim());
        logger.i(jsonResponse);
        List<dynamic> choices = jsonResponse['choices'];
        logger.i(choices);
        Map<String, dynamic> firstChoice = choices[0];
        logger.i(firstChoice);
        Map<String, dynamic> message = firstChoice['message'];
        logger.i(message);
        String content = message['content'];
        logger.i(content);
        Map<String, dynamic> contentJson = json.decode(content.trim());
        logger.i(contentJson);

        logger.i(contentJson["title"]);
        logger.i(contentJson["story"]);
        /* String title = contentJson['title'].toString();
        logger.i(title);
        
        String story = contentJson['story'].toString();
        logger.i(story); */

        return {"title": "title", "story": "story"};
      }else {
         logger.e('Something went wrong');
        throw Exception('Failed to load data');
      }
    } catch (error) {
       logger.e('Error: $error');
      // Handle the error
      throw Exception('Failed to load data');
    }
  }
}