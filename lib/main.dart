import 'dart:math';

import 'package:flutter/material.dart';
import 'theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guess Random Number',
      theme: AppTheme.theme,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _textEditingController = TextEditingController();

  final String _title = 'Guess the number!';
  String _try = 'Try a number!';
  String _elevatedButtonText = 'Guess';
  late int _randomNumber;
  late int userNumber;
  late FocusNode _focusNode;
  bool gameEnded = false;

  @override
  void initState() {
    super.initState();
    _randomNumber = _generateRandomNumber(1, 100);
    _focusNode = FocusNode();
  }

  int _generateRandomNumber(int min, int max) {
    final Random random = Random();
    return min + random.nextInt(max - min + 1);
  }

  String higherLower(int tryNumber) {
    if (tryNumber == _randomNumber) {
      return 'is equal';
    } else if (tryNumber > _randomNumber) {
      return 'is higher';
    } else {
      return 'is lower';
    }
  }

  void _resetGame() {
    _elevatedButtonText = 'Guess';
    _randomNumber = _generateRandomNumber(1, 100);
    _textEditingController.text = '';
    setState(() {
      _try = 'Try a number!';
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _title,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
          style: const TextStyle(
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(
              vertical: 30, horizontal: 15),
          child: Column(
            children: <Widget>[
              const Text(
                "I'm thinking of a number between 1 and 100.",
                textDirection: TextDirection.ltr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: Text(
                  "It's your turn to guess the number!",
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.ltr,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _focusNode.unfocus();
                },
                child: FocusScope(
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(color: Colors.deepPurpleAccent),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: <Widget>[
                          const SizedBox(
                            height: 16,
                          ),
                          Text(
                            _try,
                            style: const TextStyle(
                              fontSize: 26,
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                            width: 16,
                          ),
                          TextField(
                            keyboardType: TextInputType.number,
                            controller: _textEditingController,
                            decoration: InputDecoration(
                              hintText: _elevatedButtonText == 'Guess'
                                  ? 'Your number is: '
                                  : '',
                              labelText: 'Number *',
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                _focusNode.unfocus();
                                if (_elevatedButtonText == 'Reset') {
                                  _resetGame();
                                }
                                userNumber =
                                    int.parse(_textEditingController.text);
                                if (higherLower(userNumber) == 'is equal') {
                                  _dialogBuilder(context);
                                }

                                setState(() {
                                  if (higherLower(userNumber) == 'is higher') {
                                    _try = 'You tried $userNumber\nTry lower!';
                                  } else if (higherLower(userNumber) ==
                                      'is '
                                          'lower') {
                                    _try = 'You tried $userNumber\nTry higher!';
                                  }
                                });
                              },
                              child: Text(_elevatedButtonText)),
                          const SizedBox(
                            height: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('You were right!'),
          content: Text('The number was $_randomNumber!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _randomNumber = _generateRandomNumber(1, 100);
                _textEditingController.text = '';
                Navigator.of(context).pop();
                _resetGame();
                setState(() {
                  _elevatedButtonText = 'Guess';
                });
                _try = 'The right number was $userNumber!';
              },
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Try again'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _textEditingController.clear();
                  _try = 'Play again?';
                  _elevatedButtonText = 'Reset';
                });
              },
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
