import 'package:flutter/material.dart';
import 'screens/startpage.dart';
import 'screens/homepage.dart';
import 'screens/quizpage.dart';
import 'screens/reportpage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GoQuiz',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => StartPage(),
        '/home': (context) => HomePage(),
        '/quiz': (context) => QuizPage(category: ''),
        '/report': (context) => ReportPage(score: 0),
      },
    );
  }
}
