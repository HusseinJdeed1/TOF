import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../services/firebase_service.dart';

class GamePageProvider extends ChangeNotifier {
  final Dio _dio = Dio();
  List? questions;
  int _currentQuestionIndex = 0;
  var data;
  BuildContext context;
  String? difficultylevel;
  int? maxNumQuestion;
  String? category;
  int correctCount = 0;
  GamePageProvider({
    required this.context,
    this.difficultylevel,
    this.maxNumQuestion,
    this.category,
  }) {
    _dio.options.baseUrl = "https://opentdb.com/api.php/";
    _getQuestionsFromAPI();
    _getCategoriesFromAPI();
  }
  List<Map<String, String>> categories = [];
  FirebaseService? firebaseService;

  Future<void> _getCategoriesFromAPI() async {
    try {
      var response = await _dio.get("https://opentdb.com/api_category.php");

      data = jsonDecode(response.toString());
      categories = (data["trivia_categories"] as List<dynamic>)
          .map((item) =>
              {"id": item["id"].toString(), "name": item["name"].toString()})
          .toList(); // print(categories);
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    notifyListeners();
  }

  Future<void> _getQuestionsFromAPI() async {
    try {
      var response = await _dio.get("", queryParameters: {
        "amount": maxNumQuestion.toString(),
        "category": category,
        "difficulty": difficultylevel!.toLowerCase(),
        "type": "boolean",
      });

      data = jsonDecode(response.toString());
      questions = data["results"];
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    notifyListeners();
  }

  String currentQuestionText() {
    return questions![_currentQuestionIndex]["question"];
  }

  void answerQuestion(String _answer) async {
    bool isCorrect =
        questions![_currentQuestionIndex]["correct_answer"] == _answer;
    correctCount += isCorrect ? 1 : 0;
    _currentQuestionIndex++;

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
            title: Icon(isCorrect ? Icons.check_circle : Icons.cancel_sharp,
                color: Colors.white, size: 45),
            backgroundColor: isCorrect ? Colors.green : Colors.red,
          );
        });
    await Future.delayed(Duration(seconds: 1));
    Navigator.pop(context);
    if (_currentQuestionIndex == maxNumQuestion) {
      endGame();
    } else {
      notifyListeners();
    }
  }

  Future<void> endGame() async {
    firebaseService = GetIt.instance<FirebaseService>();
    try {
      double score = correctCount / maxNumQuestion!;
      print(score);
      await firebaseService!.setUserScore(score);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor:
                correctCount > maxNumQuestion! / 2 ? Colors.green : Colors.red,
            title: const Text("End Game",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 35,
                    fontWeight: FontWeight.w400)),
            content: Text("Score: $correctCount / $maxNumQuestion",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w200)),
          );
        },
      );
      await Future.delayed(const Duration(seconds: 3));
      Navigator.pop(context);
      Navigator.pop(context);
    } catch (e) {
      print(e);
    }
  }
}
