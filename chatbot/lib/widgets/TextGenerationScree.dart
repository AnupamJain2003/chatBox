import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(TextGenerationApp());
}

class TextGenerationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Text Generation App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TextGenerationScreen(),
    );
  }
}

class TextGenerationScreen extends StatefulWidget {
  @override
  _TextGenerationScreenState createState() => _TextGenerationScreenState();
}

class _TextGenerationScreenState extends State<TextGenerationScreen> {
  TextEditingController _inputController = TextEditingController();
  List<Map<String, String>> _conversation = [];
ScrollController _scrollController = ScrollController(); // Initialize ScrollController

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ChatBox App'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                controller: _scrollController, // Assign ScrollController
                reverse: false,
                itemCount: _conversation.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      _conversation[index]['text']!,
                      textAlign: _conversation[index]['type'] == 'user'
                          ? TextAlign.end
                          : TextAlign.start,
                      style: TextStyle(
                        color: _conversation[index]['type'] == 'user'
                            ? Colors.blue
                            : Colors.green,
                        fontWeight: _conversation[index]['type'] == 'user'
                            ? FontWeight.normal
                            : FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _inputController,
              decoration: InputDecoration(
                labelText: 'Type your message...',
                suffixIcon: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    _sendMessage(_inputController.text);
                  },
                ),
              ),
              onSubmitted: (value) {
                _sendMessage(value);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage(String text) async {
    if (text.isNotEmpty) {
      setState(() {
        _conversation.add({'text': text, 'type': 'user'});
        _inputController.clear();
        _scrollToBottom(); // Scroll to bottom after adding a new message
      });

      try {
        final String generatedText = await generateText(text);
        setState(() {
          _conversation.add({'text': generatedText, 'type': 'bot'});
        });
      } catch (e) {
        print('Error generating text: $e');
      }
    }
  }
void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Future<String> generateText(String inputText) async {
    final Uri uri = Uri.parse('http://127.0.0.1:5000//generate_text');
    final Map<String, String> headers = {'Content-Type': 'application/json'};
    final Map<String, String> body = {'input_text': inputText};

    final http.Response response =
        await http.post(uri, headers: headers, body: jsonEncode(body));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return responseData['generated_text'] as String;
    } else {
      throw Exception('Failed to generate text: ${response.statusCode}');
    }
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
