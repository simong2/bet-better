import 'package:bet_better/services/firebase_services.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';

String openAIAPI = dotenv.env['OPEN_AI_KEY']!;

Future<String> openAiResponse(String prompt) async {
  String userAccount = await getUserData();
  prompt += userAccount;
  try {
    final res = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $openAIAPI',
      },
      body: jsonEncode({
        "model": "gpt-3.5-turbo",
        "messages": [
          {
            "role": "assistant",
            "content":
                "You are a gambling assistance. Your goal is to help users track their gambling performance, set responsible budgets, and recognize risky gambling behaviors. You do not encourage gambling but provide guidance on managing it effectively. Keep your responses concise, clear, and under 120 words. Lastly, since user can make prompt, if it is not anything that should be asked to a gambling assistance, respond that you cannot answer their question since it doesn't fit the context."
          },
          {"role": "user", "content": prompt}
        ],
      }),
    );
    if (res.statusCode == 200) {
      // print(res.body);
      String content = jsonDecode(res.body)['choices'][0]['message']['content'];
      content = content.trim();

      return content;
    } else {
      // print('Error: ${res.statusCode}');
      return 'An internal error occurred';
    }
  } catch (e) {
    return e.toString();
  }
}

Future<String> getUserData() async {
  // 4 modes
  int deposits = await AuthService().getUserStat('deposits');
  int withdrawals = await AuthService().getUserStat('withdrawals');
  int winnings = await AuthService().getUserStat('winnings');
  int losses = await AuthService().getUserStat('losses');

  return 'Users account info: deposits: \$$deposits, withdrawals: \$$withdrawals, winnings: \$$winnings, losses: \$$losses';
}
