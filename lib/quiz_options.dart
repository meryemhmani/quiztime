import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qgithub/quiz_page.dart';
import 'category.dart';

class QuizOptionsDialog extends StatefulWidget {
  final Category? category;

  const QuizOptionsDialog({this.category, Key? key}) : super(key: key);

  @override
  State<QuizOptionsDialog> createState() => _QuizOptionsDialogState();
}

class _QuizOptionsDialogState extends State<QuizOptionsDialog> {
  late int _noOfQuestions;
  late String _difficulty;
  late String _type;
  late bool processing;

  @override
  void initState() {
    super.initState();
    _noOfQuestions = 10;
    _difficulty = "easy";
    _type = "multiple"; // Default type
    processing = false;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeader(),
          _buildQuestionCountSelector(),
          _buildDifficultySelector(),
          _buildTypeSelector(),
          _buildStartButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      color: Colors.grey.shade200,
      child: Text(
        widget.category?.name ?? 'No Category',
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildQuestionCountSelector() {
    return ListTile(
      title: const Text("Number of Questions"),
      trailing: DropdownButton<int>(
        value: _noOfQuestions,
        onChanged: (value) {
          setState(() {
            _noOfQuestions = value!;
          });
        },
        items: [10, 20, 30].map<DropdownMenuItem<int>>((int value) {
          return DropdownMenuItem<int>(
            value: value,
            child: Text(value.toString()),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDifficultySelector() {
    return ListTile(
      title: const Text("Difficulty"),
      trailing: DropdownButton<String>(
        value: _difficulty,
        onChanged: (value) {
          setState(() {
            _difficulty = value!;
          });
        },
        items: ["easy", "medium", "hard"]
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return ListTile(
      title: const Text("Type"),
      trailing: DropdownButton<String>(
        value: _type,
        onChanged: (value) {
          setState(() {
            _type = value!;
          });
        },
        items: ["multiple", "true/false"]
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStartButton() {
    return ElevatedButton(
      onPressed: processing
          ? null
          : () {
        setState(() {
          processing = true;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizPage(
              category: widget.category!,
              numberOfQuestions: _noOfQuestions,
              difficulty: _difficulty,
              type: _type,
            ),
          ),
        );
      },
      child: processing
          ? const CircularProgressIndicator()
          : const Text("Start Quiz"),
    );
  }
}
