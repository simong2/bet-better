import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MoreAnalysis extends StatefulWidget {
  const MoreAnalysis({super.key});

  @override
  State<MoreAnalysis> createState() => _MoreAnalysisState();
}

class _MoreAnalysisState extends State<MoreAnalysis> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'), // open to later change
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: AspectRatio(
            aspectRatio: 2,
            child: BarChart(
              BarChartData(
                barGroups: [
                  BarChartGroupData(
                    x: 0,
                    barRods: [BarChartRodData(toY: 20)],
                  ),
                  BarChartGroupData(
                    x: 1,
                    barRods: [BarChartRodData(toY: 20)],
                  ),
                  BarChartGroupData(
                    x: 2,
                    barRods: [BarChartRodData(toY: 20)],
                  ),
                  BarChartGroupData(
                    x: 3,
                    barRods: [BarChartRodData(toY: 20)],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      // body: AspectRatio(
      //   aspectRatio: 2.0,
      //   child: LineChart(
      //     LineChartData(
      //       lineBarsData: [
      //         LineChartBarData(
      //           spots: const [
      //             FlSpot(0, 0),
      //             FlSpot(1, 1),
      //             FlSpot(2, 1),
      //             FlSpot(3, 4),
      //             FlSpot(4, 4),
      //             FlSpot(5, 2),
      //           ],
      //         )
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
