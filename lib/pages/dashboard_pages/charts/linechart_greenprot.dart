import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class LineChartWidget extends StatelessWidget {
  final List<double> greenProtocolCounts;
  final List<String> monthNames;

  const LineChartWidget({
    super.key,
    required this.greenProtocolCounts,
    required this.monthNames,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate the min and max counts from both initiatives
    double minY = [
      ...greenProtocolCounts,
    ].reduce((a, b) => a < b ? a : b);

    double maxY = [
      ...greenProtocolCounts,
    ].reduce((a, b) => a > b ? a : b);

    // Ensure there's at least a space between min and max for the Y-axis
    maxY = maxY + 1; // Add some padding to the max value for spacing
    minY = minY - 1; // Add some padding to the min value for spacing

    // Define the interval for the Y-axis labels (e.g., every 5 units)
    double range = maxY - minY;
    double interval =
    (range / 5).ceilToDouble(); // Divide range into 5 intervals

    if (minY < 0) minY = 0; // Avoid negative values on Y-axis

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Line chart
          Container(
            width: double.infinity,
            height: 145,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: LineChart(
              curve: Curves.easeInOut,
              LineChartData(
                gridData: FlGridData(show: true),
                titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 20,
                        getTitlesWidget: (value, meta) {
                          // Only show Y-axis labels at regular intervals
                          if (value % interval == 0) {
                            return Text(
                              value.toInt().toString(),
                              style: const TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),

                    // leftTitles: AxisTitles(
                    //   sideTitles: SideTitles(
                    //     showTitles: true,
                    //     reservedSize: 40,
                    //     getTitlesWidget: (value, meta) {
                    //       // double minValue =
                    //       //     banTheBagCounts.reduce((a, b) => a < b ? a : b);
                    //       // double maxValue = sustainableMenstruationCounts
                    //       //     .reduce((a, b) => a > b ? a : b);
                    //       // double range = maxValue - minValue;
                    //       // double interval = (range / 5).ceilToDouble();

                    //       if (value == 0) {
                    //         return const Text('0');
                    //       } else if (value == interval) {
                    //         return Text(interval.toString());
                    //       } else if (value == 2 * interval) {
                    //         return Text((2 * interval).toString());
                    //       } else if (value == 3 * interval) {
                    //         return Text((3 * interval).toString());
                    //       } else if (value == 4 * interval) {
                    //         return Text((4 * interval).toString());
                    //       } else if (value == 5 * interval) {
                    //         return Text((5 * interval).toString());
                    //       } else {
                    //         return const Text('');
                    //       }
                    //       // return Text(
                    //       //   value.toInt().toString(),
                    //       // style: const TextStyle(
                    //       //   fontSize: 12,
                    //       //   fontWeight: FontWeight.bold,
                    //       // ),
                    //       // );
                    //     },
                    //   ),
                    // ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: false,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            monthNames[value.toInt()],
                            style: const TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false))),
                borderData: FlBorderData(
                    show: true,
                    border: const Border(
                      bottom: BorderSide(color: Colors.grey, width: 2),
                      left: BorderSide(color: Colors.grey, width: 2),
                      right: BorderSide(color: Colors.transparent, width: 2),
                      top: BorderSide(color: Colors.transparent, width: 2),
                    )),
                lineBarsData: [
                  LineChartBarData(
                    spots: _getDataPoints(greenProtocolCounts),
                    isCurved: true,
                    show: true,
                    barWidth: 2,
                    color: Colors.blue,
                    isStrokeCapRound: true,
                    belowBarData: BarAreaData(show: false),
                    dotData: FlDotData(show: true),
                  ),
                ],
              ),
            ),
          ),

          // Legend
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 10),
              Container(
                width: 20,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Green Protocol',
                style: TextStyle(
                  fontSize: 7,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Converts data list into chart points (FlSpot)
  List<FlSpot> _getDataPoints(List<double> data) {
    return List.generate(data.length, (index) {
      return FlSpot(index.toDouble(), data[index]);
    });
  }
}