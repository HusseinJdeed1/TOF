import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../providers/game_page_provider.dart';
import '../services/firebase_service.dart';
import 'profile_page.dart';

class GamePage extends StatefulWidget {
  GamePage(
      {required this.difficultylevel,
      required this.numberOfQuestion,
      required this.questionCategory});

  final String difficultylevel;
  final int numberOfQuestion;
  final String questionCategory;

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  double? _deviceHeight, _deviceWidth;

  GamePageProvider? gamePageProvider;

  FirebaseService? firebaseService;

  void initState() {
    super.initState();
    firebaseService = GetIt.instance.get<FirebaseService>();
  }

  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;
    return ChangeNotifierProvider(
        create: (context) => GamePageProvider(
              context: context,
              difficultylevel: widget.difficultylevel,
              category: widget.questionCategory,
              maxNumQuestion: widget.numberOfQuestion,
            ),
        child: _buildUI());
  }

  Widget _buildUI() {
    return Builder(builder: (context) {
      gamePageProvider = context.watch<GamePageProvider>();
      if (gamePageProvider!.questions != null &&
          gamePageProvider!.questions!.isNotEmpty) {
        return SafeArea(
            child: Scaffold(
                appBar: AppBar(
                  actions: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfilePage(),
                            ));
                      },
                      child: const Icon(Icons.person),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 8.0,
                        right: 8.0,
                      ),
                      child: GestureDetector(
                        onTap: () async {
                          await firebaseService!.logout();
                          Navigator.pushNamedAndRemoveUntil(
                              context, "login", (route) => false);
                        },
                        child: const Icon(Icons.logout),
                      ),
                    ),
                  ],
                ),
                body: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: _deviceWidth! * 0.1),
                    child: _gameUI())));
      } else {
        return const Center(
          child: SpinKitFadingFour(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
        );
      }
    });
  }

  Widget _gameUI() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          _questionText(),
          Column(
            children: [
              _trueButton(),
              SizedBox(
                height: _deviceHeight! * 0.01,
              ),
              _falseButton(),
            ],
          ),
        ]);
    ;
  }

  Widget _questionText() {
    return Text(
      gamePageProvider!.currentQuestionText(),
      style: const TextStyle(
          color: Colors.white, fontSize: 25, fontWeight: FontWeight.w400),
    );
  }

  Widget _trueButton() {
    return MaterialButton(
      height: _deviceHeight! * 0.1,
      minWidth: _deviceWidth! * 0.8,
      onPressed: () {
        gamePageProvider?.answerQuestion("True");
      },
      color: Colors.green,
      child: const Text("True",
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w200)),
    );
  }

  Widget _falseButton() {
    return MaterialButton(
      height: _deviceHeight! * 0.1,
      minWidth: _deviceWidth! * 0.8,
      onPressed: () {
        gamePageProvider?.answerQuestion("False");
      },
      color: Colors.red,
      child: const Text("False",
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w200)),
    );
  }
}
