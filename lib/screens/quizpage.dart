import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mohd_sami_task3/screens/reportpage.dart';

class QuizPage extends StatefulWidget {
  final String category;

  QuizPage({required this.category});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int questionIndex = 0;
  int score = 0;
  List questions = [];
  Timer? timer;
  int timeLeft = 30;

  String? selectedAnswer;
  bool isAnswerSelected = false;

  final Map<String, int> categoryIds = {
    'General Knowledge': 9,
    'Entertainment: Books': 10,
    'Entertainment: Film': 11,
    'Sports': 21,
    'Science': 17,
    'History': 23,
    'Movies': 11,
    'Music': 12,
    'Technology': 18,
    'Pop Culture': 14,
    'Fashion': 26,
    'Food': 19,
    'Animals': 27,
  };

  @override
  void initState() {
    super.initState();
    fetchQuestions();
    startTimer();
  }

  Future<void> fetchQuestions() async {
    int categoryId = categoryIds[widget.category] ?? 9;
    final response = await http.get(Uri.parse(
        'https://opentdb.com/api.php?amount=10&category=$categoryId&type=multiple'));

    if (response.statusCode == 200) {
      setState(() {
        questions = json.decode(response.body)['results'];
        // Shuffle options for each question only once
        for (var question in questions) {
          List<String> options =
              List<String>.from(question['incorrect_answers']);
          options.add(question['correct_answer']);
          options.shuffle();
          question['options'] = options;
        }
      });
    } else {
      print('Failed to load questions');
    }
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        if (timeLeft > 0) {
          timeLeft--;
        } else {
          nextQuestion();
        }
      });
    });
  }

  void nextQuestion() {
    if (selectedAnswer == questions[questionIndex]['correct_answer']) {
      score++;
    }

    if (questionIndex < questions.length - 1) {
      setState(() {
        questionIndex++;
        timeLeft = 30;
        selectedAnswer = null; // Reset selected answer for next question
        isAnswerSelected = false; // Reset answer selection flag
      });
    } else {
      timer?.cancel();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ReportPage(score: score)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) return Center(child: CircularProgressIndicator());

    final question = questions[questionIndex];
    List<String> options = List<String>.from(question['options']);

    return Scaffold(
      appBar: AppBar(title: Text("Category: ${widget.category}")),
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple.shade300, Colors.deepPurple.shade600],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Question ${questionIndex + 1}",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                SizedBox(height: 10),
                Text(question['question'],
                    style: TextStyle(fontSize: 18, color: Colors.white)),
                SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      String option = options[index];
                      return GestureDetector(
                        onTap: () {
                          if (!isAnswerSelected) {
                            setState(() {
                              selectedAnswer = option;
                              isAnswerSelected = true;
                            });
                            // Delay moving to the next question to show the feedback
                            Future.delayed(Duration(seconds: 1), () {
                              nextQuestion();
                            });
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: _getAnswerColor(option),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 5,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            option,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Time left: $timeLeft sec",
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Returns the color for the selected answer
  Color _getAnswerColor(String option) {
    if (selectedAnswer == null) return Colors.blueGrey.shade300;

    if (option == questions[questionIndex]['correct_answer']) {
      return Colors.green.shade500; // Correct answer: Green
    } else if (option == selectedAnswer) {
      return Colors.red.shade500; // Wrong answer: Red
    }

    return Colors.blueGrey.shade300; // Default: grey
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
