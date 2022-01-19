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
    );

    return LineChartData(
      lineBarsData: [barData],
      maxY: maxY,
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
