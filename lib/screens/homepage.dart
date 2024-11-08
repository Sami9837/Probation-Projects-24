import 'package:flutter/material.dart';
import 'package:mohd_sami_task3/screens/quizpage.dart';

class HomePage extends StatelessWidget {
  final List<String> categories = [
    'Sports',
    'Science',
    'History',
    'Movies',
    'Music',
    'Technology',
    'Pop Culture',
    'Fashion',
    'Food',
    'Animals',
  ];

  final Map<String, int> categoryIds = {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GoQuiz"),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 4,
      ),
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple.shade50, Colors.deepPurple.shade100],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Choose a Category",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    color: Colors.deepPurple,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    String category = categories[index];
                    return GestureDetector(
                      onTap: () {
                        int categoryId = categoryIds[category] ?? 9;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                QuizPage(category: categoryId.toString()),
                          ),
                        );
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 4,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              colors: [Colors.deepPurpleAccent, Colors.purple],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.deepPurpleAccent.withOpacity(0.3),
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              category,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
