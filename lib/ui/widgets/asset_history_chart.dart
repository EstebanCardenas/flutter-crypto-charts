part of charts_ui.widgets;

class AssetHistoryChart extends StatelessWidget {
  const AssetHistoryChart({
    Key? key,
    required this.intervals,
  }) : super(key: key);

  final List<AssetHistoryInterval> intervals;

  double get maxY {
    double max = intervals.fold<double>(
      0,
      (acc, i) => i.price > acc ? i.price.toDouble() : acc,
    );
    return max * 1.025;
  }

  double get minY {
    double min = intervals.fold<double>(
      double.maxFinite,
      (acc, i) => i.price < acc ? i.price.toDouble() : acc,
    );
    return min * 0.975;
  }

  LineChartData get _chartData {
    LineChartBarData barData = LineChartBarData(
      colors: [Colors.blue[200]!],
      spots: intervals
          .mapIndexed<FlSpot>(
            (idx, i) => FlSpot(
              idx.toDouble(),
              i.price.toDouble(),
            ),
          )
          .toList(),
      isCurved: true,
      belowBarData: BarAreaData(
        show: true,
        colors: [Colors.black54],
      ),
      dotData: FlDotData(show: false),
    );

    return LineChartData(
      lineBarsData: [barData],
      borderData: FlBorderData(
        show: true,
        border: const Border(
          left: BorderSide(color: Colors.black),
          bottom: BorderSide(color: Colors.black),
        ),
      ),
      titlesData: FlTitlesData(
        topTitles: SideTitles(showTitles: false),
        leftTitles: SideTitles(showTitles: false),
        bottomTitles: SideTitles(
          showTitles: true,
          interval: (intervals.length ~/ 4).toDouble(),
          getTitles: (value) {
            if (value != 0 &&
                value < intervals.length - intervals.length ~/ 4) {
              DateTime dt = intervals[value.toInt()].time;
              return '${dt.monthName(true)} ${dt.day}/${dt.shortenedYear}';
            }
            return '';
          },
          getTextStyles: (context, value) {
            return const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            );
          },
        ),
      ),
      gridData: FlGridData(
        drawVerticalLine: false,
      ),
      maxY: maxY,
      minY: minY,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: LineChart(_chartData),
      ),
    );
  }
}
