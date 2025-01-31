# BetBetter

A Flutter mobile app to track your gambling peformance to better betting habits.

## Overview
1. Simple interface for users to track their gambling activity, including:
- Deposits
- Withdrawals
- Wins from betting apps
- Losses from betting apps

2. Dashboard feature powered by [Fl Chart](https://github.com/imaNNeo/fl_chart), including:
- Bar Chart
- Pie Chart

3. Uses Firebase Firestore to store user data, with the ability for users to add/delete entries as needed.
4. Uses OpenAI GPT-3.5 Turbo API for a gambling assistance chatbot, answering basic gambling questions and personalizing responses with user data.


## Running the app
1. Clone the repository
```bash
git clone https://github.com/simong2/bet_better.git
cd bet_better
```
2. Set up a firebase project for the flutter app.
3. Set up an OpenAI API key.
4. Create a .env file and add API keys based on how they are read in lib/firebase_options.dart and lib/services/openai_services.dart.

