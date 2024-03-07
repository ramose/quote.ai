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
  String? quoteText;
  String? quoteName;
  bool isLoading = false;
  bool fetchNewQuote = true;

  late double opacityLevel;

  @override
  void initState() {
    setState(() {
      opacityLevel = 1.0;
    });
    super.initState();
  }

  void submit() async {
    setState(() {
      isLoading = true;
    });
    const prompt = 'Write a sarcasm quote.';
    final content = [Content.text(prompt)];
    final contentResponse = await model.generateContent(content);

    setState(() {
      isLoading = false;
    });

    response = contentResponse.text ?? '';

    // todo: check if response have quote maker
    // suggestion: just write the quote
    List<String> quoteParts = response!.split('-');

    quoteText = quoteParts[0];
    quoteName = quoteParts[1];

    // setState(() {
    //   opacityLevel = 1.0;
    // });
    // print(response.text);
    resetOpacity();
  }

  void onEndTextAnimation() {
    if (opacityLevel == 0) {
      submit();
    }
  }

  void resetOpacity() {
    setState(() {
      opacityLevel = opacityLevel == 1.0 ? 0.0 : 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Color.fromARGB(255, 39, 57, 65), Colors.grey])),
          ),
          const AmbientBackground(),
          Column(
            children: [
              Expanded(
                  child: Center(
                      child: Padding(
                padding: const EdgeInsets.all(28.0),
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Color.fromARGB(255, 174, 155, 131),
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedOpacity(
                            opacity: opacityLevel,
                            duration: const Duration(seconds: 1),
                            child: Text(
                              quoteText ?? '',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.06,
                                color: const Color.fromARGB(214, 241, 235, 235),
                                shadows: const <Shadow>[
                                  Shadow(
                                    offset: Offset(5.0, 5.0),
                                    blurRadius: 30.0,
                                    color: Color.fromARGB(255, 30, 30,
                                        30), // Choose the glow color
                                  ),
                                ],
                              ),
                            ),
                          ),
                          AnimatedOpacity(
                            duration: const Duration(seconds: 2),
                            onEnd: () => onEndTextAnimation(),
                            opacity: opacityLevel,
                            child: Text(
                              quoteName != null ? '-$quoteName' : '',
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05,
                                color: const Color.fromARGB(214, 241, 235, 235),
                                shadows: const <Shadow>[
                                  Shadow(
                                    offset: Offset(5.0, 5.0),
                                    blurRadius: 30.0,
                                    color: Color.fromARGB(255, 30, 30,
                                        30), // Choose the glow color
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
              ))),
              Center(
                  child: Padding(
                padding: const EdgeInsets.all(28.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(255, 174, 155, 131))),
                  child: const Text(
                    "Quote",
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    if (opacityLevel == 1.0) {
                      resetOpacity();
                    }
                  },
                ),
              )),
            ],
          ),
        ],
      ),
    );
  }
}
