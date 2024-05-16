import 'package:flutter/material.dart';
import 'package:chatbot/widgets/TextGenerationScree.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Chat Bot App',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: TextGenerationScreen(),
  ));
}
