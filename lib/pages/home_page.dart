import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/game_page_provider.dart';
import 'game_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double? _deviceHeight, _deviceWidth;
  double difficultyLevelIndex = 0;
  final List<String> difficultyText = [
    "Easy",
    "Medium",
    "Hard",
  ];

  final List<String> numberOfQuestions = [
    "5",
    "10",
    "15",
  ];

  String categoryDropDownIndex = "21";
  String numQuestionDropDownIndex = "5";
  GamePageProvider? gamePageProvider;

  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;

    return ChangeNotifierProvider(
      create: (context) => GamePageProvider(context: context),
      child: Scaffold(
        body: SafeArea(
            child: Container(
          padding: EdgeInsets.symmetric(horizontal: _deviceWidth! * 0.01),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Consumer(
                      builder: (context, GamePageProvider value, child) {
                        return _dropDownCategoryList(
                          value.categories,
                          _deviceWidth! * 0.6,
                          categoryDropDownIndex,
                        );
                      },
                    ),
                    const Spacer(
                      flex: 10,
                    ),
                    _dropDownQestionNumberList(
                      numberOfQuestions,
                      _deviceWidth! * 0.2,
                      numQuestionDropDownIndex,
                    ),
                  ],
                ),
                _appTile(),
                _difficultySlider(),
                _startButton(),
              ],
            ),
          ),
        )),
      ),
    );
  }

  Widget _appTile() {
    return Column(
      children: [
        const Text(
          "True Or False",
          style: TextStyle(
              color: Colors.white, fontSize: 45, fontWeight: FontWeight.w500),
        ),
        const Text(
          "select level",
          style: TextStyle(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
        ),
        Text(
          difficultyText[difficultyLevelIndex.toInt()],
          style: const TextStyle(color: Colors.white, fontSize: 30),
        ),
      ],
    );
  }

  Widget _difficultySlider() {
    return Slider(
        label: difficultyText[difficultyLevelIndex.toInt()],
        min: 0,
        max: 2,
        divisions: 2,
        value: difficultyLevelIndex,
        onChanged: (_value) {
          setState(() {
            difficultyLevelIndex = _value;
          });
        });
  }

  Widget _startButton() {
    return MaterialButton(
      minWidth: _deviceWidth! * 0.8,
      height: _deviceHeight! * 0.1,
      color: Colors.blue,
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return GamePage(
              difficultylevel: difficultyText[difficultyLevelIndex.toInt()],
              numberOfQuestion: int.parse(numQuestionDropDownIndex),
              questionCategory: categoryDropDownIndex,
            );
          },
        ));
      },
      child: const Text("Start",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w200,
            fontSize: 35,
          )),
    );
  }

  Widget _dropDownCategoryList(List<Map<String, String>> categories,
      double _width, String dropDownIndex) {
    return Container(
      margin: EdgeInsets.all(8),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      width: _width,
      child: Consumer(
        builder: (context, GamePageProvider value, child) {
          return DropdownButton(
            hint: Text("Select Category"),
            iconSize: 30,
            borderRadius: BorderRadius.circular(15),
            isExpanded: true,
            underline: Container(),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 15,
            ),
            value: categoryDropDownIndex,
            items: categories.map((Map<String, String> items) {
              return DropdownMenuItem(
                value: items["id"],
                child: Text(items["name"]!),
              );
            }).toList(),
            onChanged: (newIndex) {
              setState(() {
                categoryDropDownIndex = newIndex!.toString();
                print(newIndex!);
              });
            },
          );
        },
      ),
    );
  }

  Widget _dropDownQestionNumberList(
      List<String> categories, double _width, String dropDownIndex) {
    return Container(
      margin: EdgeInsets.all(8),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      width: _width,
      child: DropdownButton(
        menuMaxHeight: _deviceHeight! * 0.2,
        iconSize: 30,
        borderRadius: BorderRadius.circular(15),
        isExpanded: true,
        underline: Container(),
        style: const TextStyle(
          color: Colors.black,
          fontSize: 15,
        ),
        value: dropDownIndex,
        items: categories.map((String items) {
          return DropdownMenuItem(
            value: items,
            child: Text(items),
          );
        }).toList(),
        onChanged: (newIndex) {
          setState(() {
            numQuestionDropDownIndex = newIndex!;
          });
        },
      ),
    );
  }
}
