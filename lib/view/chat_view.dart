import 'package:flutter/material.dart';
import 'package:gemini2/elements/element.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final model = GenerativeModel(
      model: 'gemini-pro', apiKey: "AIzaSyBMxju6DQRU81wgfft6iIFFmiceCqC8Ghc");
  String? response;

  void submit() async {
    const prompt = 'Write a quote.';
    final content = [Content.text(prompt)];
    final contentResponse = await model.generateContent(content);

    setState(() {
      response = contentResponse.text;
    });
    // print(response.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Color.fromARGB(255, 39, 57, 65), Colors.grey])),
          ),
          AmbientBackground(),
          Column(
            children: [
              Expanded(
                  child: Center(
                      child: Padding(
                padding: const EdgeInsets.all(28.0),
                child: Text(
                  response ?? '',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.06,
                    color: Color.fromARGB(214, 241, 235, 235),
                    shadows: <Shadow>[
                      Shadow(
                        offset: Offset(5.0, 5.0),
                        blurRadius: 30.0,
                        color: Color.fromARGB(255, 30, 30, 30), // Choose the glow color
                      ),
                    ],
                  ),
                ),
              ))),
              Center(
                  child: Padding(
                padding: EdgeInsets.all(28.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Color.fromARGB(255, 174, 155, 131))),
                  child: Text(
                    "Submit",
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () => submit(),
                ),
              )),
            ],
          ),
        ],
      ),
    );
  }
}
