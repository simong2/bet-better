import 'package:bet_better/screens/history_screen.dart';
import 'package:bet_better/screens/more_analysis.dart';
import 'package:bet_better/services/firebase_services.dart';
import 'package:bet_better/widgets/enter_amount_dialog.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// checks for host device
import 'dart:io' show Platform;

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController _controller = TextEditingController();

  /*
  False: less than zero, make number red
  True: Greater than zero, make number green
   */
  bool ifNeg(String number) {
    int x = int.parse(number);
    if (x < 0) {
      return false;
    }
    return true;
  }

  bool locked = true;
  late SharedPreferences _prefs;

  void _initPref() async {
    _prefs = await SharedPreferences.getInstance();
    _getPref();
  }

  Future<void> _setPref(bool locked) async {
    await _prefs.setBool('isLocked', locked);
    // print('locked value: ${_prefs.getBool('isLocked')}');
  }

  void _getPref() {
    try {
      // make get request
      setState(() {
        locked = _prefs.getBool('isLocked')!;
      });
    } catch (e) {
      print('here is the error:\n$e');
      _setPref(locked);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initPref();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double cardSize = height * .22;
    // print(cardSize);
    double width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        title: const Text('BetBetter'),
        actions: [
          IconButton(
            onPressed: () async {
              setState(() {
                locked = !locked;
              });
              await _setPref(locked);
            },
            icon: locked
                ? const Icon(Icons.lock_open_outlined)
                : const Icon(Icons.lock_outline),
          ),

          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HistoryScreen(),
                ),
              );
            },
            icon: const Icon(Icons.history),
          ),

          /// delete account
          // TextButton(
          //   onPressed: () {
          //     // signOutAnon();
          //     print('deleting account...');
          //     AuthService().signOutAnon();
          //   },
          //   child: const Text('Delete account'),
          // )
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: SizedBox(
                height: cardSize,
                width: double.infinity,
                child: Card(
                  elevation: 0,
                  color: Colors.white,
                  child: Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: Column(
                          children: [
                            const Text(
                              'Net Profit',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // moves it to 'half'
                            SizedBox(height: cardSize / 3),
                            // withdrawals - deposits
                            StreamBuilder(
                              stream: AuthService().performNetProfit(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return const Center(
                                      child: Text('Error loading data.'));
                                } else {
                                  // String type
                                  var result = snapshot.data!;
                                  return Center(
                                    child: locked
                                        ? Text(
                                            '\$$result',
                                            style: TextStyle(
                                              fontSize: width * .075,
                                              fontWeight: FontWeight.bold,
                                              color: ifNeg(result)
                                                  ? Colors.green
                                                  : Colors.red,
                                            ),
                                          )
                                        : Text(
                                            '*****',
                                            style: TextStyle(
                                              fontSize: width * .075,
                                            ),
                                          ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      const VerticalDivider(),
                      Flexible(
                        flex: 1,
                        child: Column(
                          children: [
                            const Text(
                              'Gambling Performance',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // moves it to 'half'
                            SizedBox(height: cardSize / 3),
                            // winnings - losses
                            StreamBuilder(
                              stream: AuthService().performNetGambling(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return const Text('Error loading data.');
                                } else {
                                  var result = snapshot.data!;
                                  return Center(
                                    child: locked
                                        ? Text(
                                            '\$$result',
                                            style: TextStyle(
                                              fontSize: width * .075,
                                              fontWeight: FontWeight.bold,
                                              color: ifNeg(result)
                                                  ? Colors.green
                                                  : Colors.red,
                                            ),
                                          )
                                        : Text(
                                            '*****',
                                            style: TextStyle(
                                              fontSize: width * .075,
                                            ),
                                          ),
                                  );
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: Colors.white,
                          title: const Text('Calculations'),
                          content: const Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Net Profit',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text('Withdrawals - Deposits'),
                              // RichText(
                              //   text: const TextSpan(
                              //     style: TextStyle(color: Colors.black),
                              //     children: [
                              //       TextSpan(
                              //         text: 'Net Profit\n',
                              //         style: TextStyle(
                              //           fontWeight: FontWeight.bold,
                              //         ),
                              //       ),
                              //       TextSpan(
                              //         text: 'Withdrawals - Deposits',
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              SizedBox(height: 10),
                              Text(
                                'Gambling Performance',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text('Winnings - Losses'),
                              // RichText(
                              //   text: const TextSpan(
                              //     style: TextStyle(color: Colors.black),
                              //     children: [
                              //       TextSpan(
                              //         text: 'Gambling Performance\n',
                              //         style: TextStyle(
                              //           fontWeight: FontWeight.bold,
                              //         ),
                              //       ),
                              //       TextSpan(
                              //         text: 'Winnings - Losses',
                              //       ),
                              //     ],
                              //   ),
                              // ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Close'),
                            )
                          ],
                        );
                      },
                    );
                  },
                  icon: const Icon(
                    Icons.help_outline,
                  ),
                ),
                TextButton(
                  style:
                      TextButton.styleFrom(foregroundColor: Colors.blueAccent),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MoreAnalysis(),
                      ),
                    );
                  },
                  child: const Text('View Charts →'),
                )
              ],
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Actions',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                ListTile(
                  title: const Text('Deposits'),
                  subtitle: const Text('Money added to account from a bank'),
                  onTap: () {
                    Platform.isIOS
                        ? showDialogPanelIos(context, _controller, 'deposits')
                        : showDialogPaneAndroid(
                            context, _controller, 'deposits');
                  },
                ),
                const Divider(height: 5),
                ListTile(
                  title: const Text('Withdrawals'),
                  subtitle: const Text('Money withdrawn from the betting app'),
                  onTap: () {
                    Platform.isIOS
                        ? showDialogPanelIos(
                            context, _controller, 'withdrawals')
                        : showDialogPaneAndroid(
                            context, _controller, 'withdrawals');
                  },
                ),
                const Divider(height: 5),
                ListTile(
                  title: const Text('Winnings'),
                  subtitle: const Text('Money won from bets'),
                  onTap: () {
                    Platform.isIOS
                        ? showDialogPanelIos(context, _controller, 'winnings')
                        : showDialogPaneAndroid(
                            context, _controller, 'winnings');
                  },
                ),
                const Divider(height: 5),
                ListTile(
                  title: const Text('Losses'),
                  subtitle: const Text('Money lost through bets'),
                  onTap: () {
                    Platform.isIOS
                        ? showDialogPanelIos(context, _controller, 'losses')
                        : showDialogPaneAndroid(context, _controller, 'losses');
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
