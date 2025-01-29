import 'package:bet_better/services/firebase_services.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('History'),
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: AuthService().getUserHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong...'));
          } else if (snapshot.data!.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('No History'),
                  Text('Place some bets and make some money'),
                ],
              ),
            );
          } else {
            final data = snapshot!.data;
            return ListView.separated(
              itemCount: data!.length,
              itemBuilder: (_, index) {
                var curr = data[index];

                return ListTile(
                  title: Text(
                    'Type: ${curr['type']}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'Amount: \$${curr['amount'].toString()}\nDate: ${formatTimeStamp(curr['timestamp'])}',
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  isThreeLine: true,
                  trailing: IconButton(
                    onPressed: () {
                      AuthService().deleteHistory(
                        curr['id'],
                        curr['type'],
                        curr['amount'],
                      );
                      // force refresh
                      setState(() {});
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider();
              },
            );
          }
        },
      ),
    );
  }
}

String capitalFirst(String word) {
  return word[0].toUpperCase() + word.substring(1, word.length - 1);
}

String formatTimeStamp(Timestamp ts) {
  DateTime d = ts.toDate();
  String format = DateFormat('M/D/yy').format(d);
  return format;
}
