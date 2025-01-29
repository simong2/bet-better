import 'package:flutter/material.dart';

class GenerateReport extends StatefulWidget {
  const GenerateReport({super.key});

  @override
  State<GenerateReport> createState() => _GenerateReportState();
}

class _GenerateReportState extends State<GenerateReport> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Generate report'),
    );
  }
}
