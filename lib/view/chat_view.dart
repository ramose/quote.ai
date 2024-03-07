import 'package:flutter/material.dart';
import 'package:gemini2/elements/element.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class QuoteView extends StatefulWidget {
  const QuoteView({super.key});

  @override
  State<QuoteView> createState() => _QuoteViewState();
}

class _QuoteViewState extends State<QuoteView> {
  final model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: "YOUR-API-KEY-HERE",
      safetySettings: [
        SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.high),
        SafetySetting(HarmCategory.harassment, HarmBlockThreshold.high),
        SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.high),
      ]);
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
    const prompt = 'Write a funny quote.';
    final content = [Content.text(prompt)];
    final contentResponse = await model.generateContent(content);

    setState(() {
      isLoading = false;
    });

    print('--> length: ${contentResponse.candidates.length}');

    response = contentResponse.text ?? '';

    // todo: check if response have quote maker
    // suggestion: just write the quote
    // List<String> quoteParts = response!.split('-');

    quoteText = response;
    // quoteName = quoteParts[1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              color: Colors.white,
            ),
            Column(
              children: [
                Center(
                  child: Text('quote.ai'),
                ),
                Expanded(
                    child: Center(
                        child: Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.black,
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              quoteText ?? '',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.06,
                                color: Colors.black,
                              ),
                            ),
                            Text(
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
                          ],
                        ),
                ))),
                // Center(
                //     child: Padding(
                //   padding: const EdgeInsets.all(28.0),
                //   child: ElevatedButton(
                //     style: ButtonStyle(
                //         backgroundColor: MaterialStateProperty.all(
                //             const Color.fromARGB(255, 174, 155, 131))),
                //     child: const Text(
                //       "Q",
                //       style: TextStyle(color: Colors.black),
                //     ),
                //     onPressed: () {},
                //   ),
                // )),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(38.0),
        child: FloatingActionButton(
          mini: true,
          onPressed: () => submit(),
          backgroundColor: Colors.black,
          // child: Text(
          //   "Q",
          //   style: TextStyle(
          //       color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
          // ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
