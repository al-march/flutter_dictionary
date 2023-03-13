import 'package:dictionary/screens/dictionary_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/template/center_scroll.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome!'),
      ),
      body: Container(
        constraints: const BoxConstraints.expand(),
        child: CenterScroll(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              const Image(image: AssetImage('assets/images/sofa-man.png')),
              const Text(
                "Запомни все новые слова",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 40),
              Container(
                constraints: const BoxConstraints(maxWidth: 400),
                child: const Text(
                  "Lorem ipsum dolor sit amet, consectetur adipisicing. Maxime, tempore! Animi nemo aut atque,  deleniti nihil dolorem repellendus.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => const DictionaryScreen(),
                      ))
                },
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text("К словарю"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
