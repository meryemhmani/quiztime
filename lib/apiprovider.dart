import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:qgithub/question.dart';
import 'category.dart';

const String baseUrl = "https://opentdb.com/api.php";

Future<List<Question>> getQuestions(
    Category category,
    int numberOfQuestions,
    String difficulty,
    String type,
    ) async {
  try {
    String urlString = '$baseUrl?amount=$numberOfQuestions&category=${category.id}&difficulty=$difficulty&type=$type';

    Uri url = Uri.parse(urlString);

    // Effectuer la requête HTTP
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Si la réponse est valide, analyser le corps JSON pour obtenir les questions
      return parseQuestions(response.body);
    } else {
      throw Exception('Failed to load questions');
    }
  } catch (e) {
    print('Error in getQuestions: $e');
    rethrow; // Propager l'exception pour un traitement ultérieur
  }
}

// Fonction pour analyser le corps JSON et le convertir en une liste d'objets Question
List<Question> parseQuestions(String body) {
  final Map<String, dynamic> parsed = json.decode(body);
  final List<dynamic> results = parsed['results'];

  // Convertir chaque élément de "results" en un objet Question
  return results.map((questionData) => Question.fromJson(questionData)).toList();
}
