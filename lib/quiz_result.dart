import 'package:flutter/material.dart';
import 'package:qgithub/question.dart';
import 'category.dart';
import 'quiz_page.dart'; // Import the quiz page.

class QuizResultsPage extends StatelessWidget {
  final int score;
  final List<Question> questions;
  final Category category; // Add category to be passed

  QuizResultsPage({required this.score, required this.questions, required this.category}); // Add category to constructor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz Results"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Final score display
            Text(
              'You scored $score / ${questions.length}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // Display the answers
            Expanded(
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  Question question = questions[index];
                  bool isCorrect =
                      question.correctAnswer == question.selectedAnswer;

                  return ListTile(
                    title: Text(question.question),
                    subtitle: Text(
                      'Your answer: ${question.selectedAnswer}\nCorrect answer: ${question.correctAnswer}',
                      style: TextStyle(
                        color: isCorrect ? Colors.green : Colors.red,
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            // Buttons to replay or go to home
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Replay the quiz with the same category
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuizPage(
                          category: category, // Pass the selected category
                          numberOfQuestions: 10, // Example: you can pass any valid number
                          difficulty: 'easy',
                          type: 'multiple',
                        ),
                      ),
                    );
                  },
                  child: Text('Replay Quiz'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Go to home screen
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: Text('Go to Home'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
