import 'package:flutter/material.dart';
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
  bool isLoading = false;

  void submit() async {
    setState(() {
      isLoading = true;
    });

    const prompt = 'Write a funny quote.';
    final content = [Content.text(prompt)];
    final contentResponse = await model.generateContent(content);

    setState(() {
      isLoading = false;
      response = contentResponse.text ?? '';
      quoteText = response;
    });
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
                const Center(
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
                          ],
                        ),
                ))),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(38.0),
        child: FloatingActionButton(
          mini: true,
          onPressed: () {
            if (!isLoading) submit();
          },
          backgroundColor: Colors.black,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
