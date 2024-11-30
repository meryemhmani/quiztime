import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qgithub/question.dart';  // Make sure the Question class is imported
import 'package:qgithub/quiz_result.dart';
import 'apiprovider.dart';
import 'category.dart';
import 'colors.dart';

class QuizPage extends StatefulWidget {
  final Category category;
  final int numberOfQuestions;
  final String difficulty;
  final String type;

  const QuizPage({
    required this.category,
    required this.numberOfQuestions,
    required this.difficulty,
    required this.type,
    Key? key,
  }) : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  var currentQuestionIndex = 0;
  int seconds = 60;
  Timer? timer;
  late Future quiz;
  int points = 0;
  var optionsColor = [
    Colors.white,
    Colors.white,
    Colors.white,
    Colors.white,
  ];

  late List<Question> questionsData;  // List of Question objects

  @override
  void initState() {
    super.initState();
    quiz = getQuestions(
      widget.category,
      widget.numberOfQuestions,
      widget.difficulty,
      widget.type,
    );
    startTimer();
  }

  resetColors() {
    setState(() {
      optionsColor = [Colors.white, Colors.white, Colors.white, Colors.white];
    });
  }

  startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (seconds > 0) {
          seconds--;
        } else {
          gotoNextQuestion();
        }
      });
    });
  }

  gotoNextQuestion() {
    if (currentQuestionIndex < widget.numberOfQuestions - 1) {
      setState(() {
        currentQuestionIndex++;
        resetColors();
        seconds = 60; // Reset timer
      });
    } else {
      timer?.cancel();
      _showQuizFinished();
    }
  }

  _showQuizFinished() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QuizResultsPage(
          score: points,
          questions: questionsData,  // Pass the list of Question objects
          category: widget.category,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.name),
      ),
      body: FutureBuilder(
        future: quiz,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error loading quiz data"));
          } else if (snapshot.hasData) {
            var data = snapshot.data["results"];

            // Map the API response into a list of Question objects
            questionsData = List<Question>.from(
              data.map((questionData) => Question.fromMap(questionData)),
            );

            return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Display current question
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        questionsData[currentQuestionIndex].question,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    // Display answers
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: questionsData[currentQuestionIndex].answers.length,
                      itemBuilder: (context, index) {
                        var answer = questionsData[currentQuestionIndex].correctAnswer;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (answer == questionsData[currentQuestionIndex].answers[index]) {
                                optionsColor[index] = Colors.green;
                                points += 10;
                              } else {
                                optionsColor[index] = Colors.red;
                              }
                              if (currentQuestionIndex < widget.numberOfQuestions - 1) {
                                Future.delayed(const Duration(seconds: 1), () {
                                  gotoNextQuestion();
                                });
                              } else {
                                timer?.cancel();
                                _showQuizFinished();
                              }
                            });
                          },
                          child: Container(
                            height: size.height * 0.08,
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: optionsColor[index],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(questionsData[currentQuestionIndex].answers[index]),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(child: Text("No quiz data available"));
          }
        },
      ),
    );
  }
}

