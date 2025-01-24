import 'package:bet_better/services/auth.dart';
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

  void updateSelected(Set<String> newSelect) {
    setState(() {
      _currChart = newSelect;
      // print(_currChart);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'), // open to later change
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
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
                  value: 'Line Chart',
                  label: Text('Line Chart'),
                )
              ],
              selected: _currChart,
              onSelectionChanged: updateSelected,
            ),
            const SizedBox(height: 15),
            _currChart.elementAt(0) == 'Line Chart'
                ? const Center(child: Text('Coming soon...'))
                : FutureBuilder(
                    future: _getUserStats(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Column(
                          children: [
                            CircularProgressIndicator(),
                            Text(
                              'Building Bar Chart',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        );
                      } else if (snapshot.hasError) {
                        return const Center(
                            child: Text('Something went wrong...'));
                      } else {
                        return AspectRatio(
                          aspectRatio: 1.7,
                          child: BarChart(
                            BarChartData(
                              barGroups: [
                                BarChartGroupData(
                                  x: 0,
                                  barRods: [
                                    BarChartRodData(toY: deposits.toDouble()),
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
                                    BarChartRodData(toY: losses.toDouble()),
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
                          ),
                        );
                      }
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
