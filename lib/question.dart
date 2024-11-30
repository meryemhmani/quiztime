class Question {
  final String question;
  final String correctAnswer;
  final List<String> incorrectAnswers;
  final String type;
  String selectedAnswer = "";  // Add selected answer for tracking user response

  Question({
    required this.question,
    required this.correctAnswer,
    required this.incorrectAnswers,
    required this.type,
  });

  // Function to construct a Question object from JSON (used for API responses)
  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      question: json['question'],
      correctAnswer: json['correct_answer'],
      incorrectAnswers: List<String>.from(json['incorrect_answers']),
      type: json['type'],
    );
  }

  // Function to construct a Question object from map (used for local data)
  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      question: map['question'] as String,
      correctAnswer: map['correct_answer'] as String,
      incorrectAnswers: List<String>.from(map['incorrect_answers']),
      type: map['type'] as String,
    );
  }

  List<String> get answers {
    // Return a list of all possible answers (correct + incorrect)
    var allAnswers = List<String>.from(incorrectAnswers);
    allAnswers.add(correctAnswer);
    allAnswers.shuffle(); // Shuffle the answers for randomness
    return allAnswers;
  }

  // Placeholder for category, as per your code
  get category => null;
}
