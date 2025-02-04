import 'package:flutter/material.dart';

import '../services/openai_services.dart';

class Chatbot extends StatefulWidget {
  const Chatbot({super.key});

  @override
  State<Chatbot> createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  late TextEditingController _questionController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _questionController = TextEditingController();
  }

  Map<int, String> questionList = {
    1: "How do I set a budget for gambling?",
    2: "Analyze my entries for general insights",
    3: "How can I improve my gambling performance?",
  };

  String currQuestion = "";
  bool sendQ = false;
  Future<String>? responseFuture;

  // to change colors for buttons
  bool light1 = false;
  bool light2 = false;
  bool light3 = false;
  bool light4 = false;

  @override
  void dispose() {
    // TODO: implement dispose
    _questionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            ElevatedButton(
              style: light1 == true
                  ? ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).focusColor)
                  : null,
              onPressed: () {
                // print(currQuestion);
                setState(() {
                  light1 = !light1;
                  light2 = false;
                  light3 = false;
                  light4 = false;
                });
                if (light1) {
                  currQuestion = questionList[1]!;
                } else {
                  currQuestion = '';
                }
              },
              child: const Text('How do I set a budget for gambling?'),
            ),
            ElevatedButton(
              style: light2 == true
                  ? ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).focusColor)
                  : null,
              onPressed: () {
                // print(currQuestion);
                setState(() {
                  light1 = false;
                  light2 = !light2;
                  light3 = false;
                  light4 = false;
                });
                if (light2) {
                  currQuestion = questionList[2]!;
                } else {
                  currQuestion = '';
                }
              },
              child: const Text('Analyze my entries for general insights?'),
            ),
            ElevatedButton(
              style: light3 == true
                  ? ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).focusColor)
                  : null,
              onPressed: () {
                // print(currQuestion);
                setState(() {
                  light1 = false;
                  light2 = false;
                  light3 = !light3;
                  light4 = false;
                });
                if (light3) {
                  currQuestion = questionList[3]!;
                } else {
                  currQuestion = '';
                }
              },
              child: const Text('How can I improve my gambling performance?'),
            ),

            ElevatedButton(
              style: light4 == true
                  ? ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).focusColor)
                  : null,
              onPressed: () {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return Form(
                      key: _formKey,
                      child: AlertDialog(
                        backgroundColor: Colors.white,
                        title: const Text('Custom Question'),
                        content: TextFormField(
                          maxLength: 120,
                          maxLines: 3,
                          controller: _questionController,
                          validator: (value) => value!.isEmpty || value == null
                              ? 'Please enter a value'
                              : null,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              _questionController.clear();
                              Navigator.pop(context);
                              setState(() {
                                light4 = false;
                                currQuestion = "";
                              });
                            },
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                currQuestion = _questionController.text;
                                Navigator.pop(context);
                                setState(() {
                                  light1 = false;
                                  light2 = false;
                                  light3 = false;
                                  light4 = true;
                                });
                              }
                            },
                            child: const Text('Save'),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: const Text('Add custom question'),
            ),
            // const Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Text(
            //       '.',
            //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 60),
            //     ),
            //     SizedBox(width: 5),
            //     Text(
            //       '.',
            //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 60),
            //     ),
            //     SizedBox(width: 5),
            //     Text(
            //       '.',
            //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 60),
            //     ),
            //   ],
            // ),
            const Divider(
              height: 55,
              thickness: 3,
              endIndent: 45,
              indent: 45,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Bot:',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (currQuestion.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Please click on one of the questions above.'),
                          ),
                        );
                      } else {
                        setState(() {
                          sendQ = true;
                          responseFuture = openAiResponse(currQuestion);
                        });
                      }
                    },
                    icon: const Icon(
                      color: Colors.blueAccent,
                      Icons.send,
                      size: 33,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: SizedBox(
                height: height * .35,
                width: double.infinity,
                child: Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: sendQ == true
                        ? FutureBuilder(
                            future: responseFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Text('loading....');
                              } else if (snapshot.hasError) {
                                return Text(snapshot.error.toString());
                              } else if (snapshot.data!.isEmpty) {
                                return const Text('No text generated');
                              } else {
                                return Text(snapshot.data!);
                              }
                            },
                          )
                        : const Text(
                            'To get a response, select a button and hit send icon.'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
