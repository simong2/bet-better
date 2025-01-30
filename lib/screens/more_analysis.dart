import 'package:bet_better/screens/chatbot.dart';
import 'package:bet_better/services/firebase_services.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MoreAnalysis extends StatefulWidget {
  const MoreAnalysis({super.key});

  @override
  State<MoreAnalysis> createState() => _MoreAnalysisState();
}

class _MoreAnalysisState extends State<MoreAnalysis> {
  late int deposits;
  late int withdrawals;
  late int wins;
  late int losses;

  Future<void> _getUserStats() async {
    deposits = await AuthService().getUserStat('deposits');
    withdrawals = await AuthService().getUserStat('withdrawals');
    wins = await AuthService().getUserStat('winnings');
    losses = await AuthService().getUserStat('losses');
  }

  Set<String> _currChart = {'Bar Chart'};

  void _updateSelected(Set<String> newSelect) {
    setState(() {
      _currChart = newSelect;
      // print(_currChart);
    });
  }

  int _currentPage = 0;

  void _updatePage(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            _currentPage == 0 ? const Text('Dashboard') : const Text('ChatBot'),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: _currentPage == 0
          ? SingleChildScrollView(
              padding: const EdgeInsets.only(top: 5.0),
              child: Column(
                children: [
                  SegmentedButton(
                    segments: const [
                      ButtonSegment(
                        value: 'Bar Chart',
                        label: Text('Bar Chart'),
                      ),
                      ButtonSegment(
                        value: 'Pie Chart',
                        label: Text('Pie Chart'),
                      ),
                    ],
                    selected: _currChart,
                    onSelectionChanged: _updateSelected,
                  ),
                  const SizedBox(height: 25),
                  FutureBuilder(
                    future: _getUserStats(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return const Center(
                            child: Text('Something went wrong...'));
                      } else {
                        // getting percentages for pie chart
                        int total = deposits + wins + losses + withdrawals;
                        String depositsPercent =
                            ((deposits / total) * 100).toStringAsFixed(0);
                        String winsPercent =
                            ((wins / total) * 100).toStringAsFixed(0);
                        String lossesPercent =
                            ((losses / total) * 100).toStringAsFixed(0);
                        String withdrawalsPercent =
                            ((withdrawals / total) * 100).toStringAsFixed(0);

                        return AspectRatio(
                          aspectRatio: 1.7,
                          child: _currChart.elementAt(0) == 'Bar Chart'
                              ? BarChart(
                                  BarChartData(
                                    barGroups: [
                                      BarChartGroupData(
                                        x: 0,
                                        barRods: [
                                          BarChartRodData(
                                              toY: deposits.toDouble()),
                                        ],
                                      ),
                                      BarChartGroupData(
                                        x: 1,
                                        barRods: [
                                          BarChartRodData(
                                              toY: withdrawals.toDouble()),
                                        ],
                                      ),
                                      BarChartGroupData(
                                        x: 2,
                                        barRods: [
                                          BarChartRodData(toY: wins.toDouble()),
                                        ],
                                      ),
                                      BarChartGroupData(
                                        x: 3,
                                        barRods: [
                                          BarChartRodData(
                                              toY: losses.toDouble()),
                                        ],
                                      ),
                                    ],
                                    titlesData: FlTitlesData(
                                      topTitles: const AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: false,
                                        ),
                                      ),

                                      /// for left tile
                                      // leftTitles: const AxisTitles(
                                      //   sideTitles: SideTitles(showTitles: false),
                                      // ),

                                      bottomTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          getTitlesWidget: (value, meta) {
                                            String text;
                                            switch (value.toInt()) {
                                              case 0:
                                                text = 'Dep.';
                                                break;
                                              case 1:
                                                text = 'Withdr.';
                                                break;
                                              case 2:
                                                text = 'Wins';
                                                break;
                                              case 3:
                                                text = 'Loses';
                                                break;
                                              default:
                                                text = '';
                                                break;
                                            }
                                            return SideTitleWidget(
                                              axisSide: AxisSide.bottom,
                                              space: 4,
                                              child: Text(text),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : PieChart(
                                  PieChartData(
                                    sections: [
                                      PieChartSectionData(
                                        value: deposits.toDouble(),
                                        title: '$depositsPercent%',
                                        color: Colors.red,
                                      ),
                                      PieChartSectionData(
                                        value: withdrawals.toDouble(),
                                        title: '$withdrawalsPercent%',
                                        color: Colors.green,
                                      ),
                                      PieChartSectionData(
                                        value: wins.toDouble(),
                                        title: '$winsPercent%',
                                      ),
                                      PieChartSectionData(
                                        value: losses.toDouble(),
                                        title: '$lossesPercent%',
                                        color: Colors.purple,
                                      ),
                                    ],
                                  ),
                                ),
                        );
                      }
                    },
                  ),
                  if (_currChart.elementAt(0) == 'Pie Chart')
                    const SizedBox(height: 30),
                  if (_currChart.elementAt(0) == 'Pie Chart')
                    drawColorsForPie(),
                  if (_currChart.elementAt(0) == 'Pie Chart') showHelperText(),
                ],
              ),
            )
          : const Chatbot(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.add_chart,
              ),
              label: 'Charts'),
          BottomNavigationBarItem(
            icon: Icon(Icons.smart_toy),
            label: 'AI Coach',
          ),
        ],
        currentIndex: _currentPage,
        onTap: _updatePage,
      ),
    );
  }
}

Widget drawColorsForPie() {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: 35,
            width: 35,
            color: Colors.red,
          ),
          Container(
            height: 35,
            width: 35,
            color: Colors.green,
          ),
        ],
      ),
      const Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('     Deposits'),
          Text('Withdrawals '),
        ],
      ),
      const SizedBox(height: 30),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: 35,
            width: 35,
            color: Colors.cyan,
          ),
          Container(
            height: 35,
            width: 35,
            color: Colors.purple,
          ),
        ],
      ),
      const Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('  Wins'),
          Text('Losses'),
        ],
      ),
    ],
  );
}

Widget showHelperText() {
  return const Column(
    children: [
      SizedBox(height: 30),
      Card(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Text('If there is no pie chart, go back and add data.'),
        ),
      )
    ],
  );
}
