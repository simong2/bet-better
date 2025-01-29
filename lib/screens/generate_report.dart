import 'package:flutter/material.dart';

class GenerateReport extends StatefulWidget {
  const GenerateReport({super.key});

  @override
  State<GenerateReport> createState() => _GenerateReportState();
}

class _GenerateReportState extends State<GenerateReport> {
  Set<String> _datePicker = {'all'};

  void _updateSelected(Set<String> newSelect) {
    setState(() {
      _datePicker = newSelect;
      // print(_datePicker);
    });
  }

  String _chartTypes = 'Both';

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 5.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Date Range',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SegmentedButton(
              segments: const [
                ButtonSegment(value: 'all', label: Text('All')),
                ButtonSegment(value: 'week', label: Text('This week')),
                ButtonSegment(value: 'month', label: Text('This month')),
                ButtonSegment(value: 'year', label: Text('This year')),
              ],
              selected: _datePicker,
              onSelectionChanged: _updateSelected,
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.only(left: 5.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Transaction Summary',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.black, fontSize: 17),
                  children: [
                    const TextSpan(
                        text:
                            'Summary of deposits, withdrawals, winnings, and losses over: '),
                    TextSpan(
                      text: _datePicker.elementAt(0),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.only(left: 5.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Charts',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            RadioListTile(
              title: const Text('Both Charts'),
              value: 'Both',
              groupValue: _chartTypes,
              onChanged: (value) {
                setState(() {
                  _chartTypes = value!;
                });
              },
            ),
            RadioListTile(
              title: const Text('Bar Chart'),
              value: 'Bar Chart',
              groupValue: _chartTypes,
              onChanged: (value) {
                setState(() {
                  _chartTypes = value!;
                });
              },
            ),
            RadioListTile(
              title: const Text('Pie Chart'),
              value: 'Pie Chart',
              groupValue: _chartTypes,
              onChanged: (value) {
                setState(() {
                  _chartTypes = value!;
                });
              },
            ),
            SizedBox(height: height / 12),
            ElevatedButton(onPressed: () {}, child: const Text('Generate PDF'))
          ],
        ),
      ),
    );
  }
}
