import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class WeekData {
  WeekData(this.date, this.food, this.exercise);
  final String date;
  final double food;
  final double exercise;
}

class WeekChart extends StatefulWidget {
  const WeekChart({@required this.weekdata, Key key}) : super(key: key);
  final List<WeekData> weekdata;

  @override
  _WeekChartState createState() => _WeekChartState();
}

class _WeekChartState extends State<WeekChart> {
  TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        primaryYAxis: NumericAxis(labelFormat: '{value} cal'),
        title: ChartTitle(
            text: "Weekly Calorie Summary",
            textStyle:
                TextStyle(fontSize: 16, color: Theme.of(context).primaryColor)),
        legend: Legend(isVisible: true, position: LegendPosition.bottom),
        tooltipBehavior: _tooltipBehavior,
        series: <ChartSeries>[
          LineSeries<WeekData, String>(
              dataSource: widget.weekdata,
              color: Theme.of(context).colorScheme.secondary,
              xValueMapper: (WeekData weekdata, _) => weekdata.date,
              yValueMapper: (WeekData weekdata, _) => weekdata.food,
              name: "Food",
              dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                  color: Theme.of(context).colorScheme.secondary)),
          LineSeries<WeekData, String>(
              dataSource: widget.weekdata,
              color: Theme.of(context).primaryColor,
              xValueMapper: (WeekData weekdata, _) => weekdata.date,
              yValueMapper: (WeekData weekdata, _) => weekdata.exercise,
              name: "Exercise",
              dataLabelSettings: DataLabelSettings(
                  isVisible: true, color: Theme.of(context).primaryColor))
        ]);
  }
}
