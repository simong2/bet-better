import 'package:bet_better/services/auth.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome!'),
            TextButton(
              onPressed: () {
                AuthService().signOutAnon();
              },
              child: const Text('Reset account'),
            )
          ],
        ),
      ),
    );
  }
}
