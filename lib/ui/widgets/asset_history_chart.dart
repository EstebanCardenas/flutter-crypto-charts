part of charts_ui.widgets;

enum _TimeUnit { days, months, years }

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

  _TimeUnit get bottomTimeUnit {
    _TimeUnit timeUnit = _TimeUnit.years;
    if (intervals.length <= 30) {
      timeUnit = _TimeUnit.days;
    } else if (intervals.length <= 365) {
      timeUnit = _TimeUnit.months;
    }
    return timeUnit;
  }

  double get interval {
    return switch (bottomTimeUnit) {
      _TimeUnit.days => 2,
      _TimeUnit.months => intervals.length < 182 ? 30 : 61,
      _TimeUnit.years => 365,
    };
  }

  String getBottomTitle(double value) {
    if (value == 0 || value == intervals.length - 1) return '';

    _TimeUnit timeUnit = bottomTimeUnit;
    DateTime dt = intervals[value.toInt()].time;
    return switch (timeUnit) {
      _TimeUnit.days => '${dt.day}',
      _TimeUnit.months => dt.monthName(true),
      _TimeUnit.years => '${dt.year}',
    };
  }

  @override
  Widget build(BuildContext context) {
    LineChartBarData barData = LineChartBarData(
      colors: [Colors.blue[200]!],
      spots: intervals
          .mapIndexed<FlSpot>(
            (idx, interval) => FlSpot(
              idx.toDouble(),
              interval.price.toDouble(),
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

    LineTouchData lineTouchData = LineTouchData(
      touchTooltipData: LineTouchTooltipData(
        getTooltipItems: (List<LineBarSpot> spots) => List.generate(
          spots.length,
          (int i) {
            LineBarSpot spot = spots[i];
            AssetHistoryInterval interval = intervals[spot.spotIndex];
            DateTime dt = interval.time;
            String formattedDate =
                '${dt.monthName(true)} ${dt.day}/${dt.shortenedYear}';

            return LineTooltipItem(
              Utils.formatCurrency(interval.price.toDouble()),
              TextStyle(
                color: Colors.blue[200]!,
                fontWeight: FontWeight.bold,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: '\n$formattedDate',
                  style: TextStyle(
                    color: Colors.blue[200]!,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );

    LineChartData chartData = LineChartData(
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
          interval: interval,
          getTitles: getBottomTitle,
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
      lineTouchData: lineTouchData,
    );

    return AspectRatio(
      aspectRatio: 1.2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: LineChart(chartData),
      ),
    );
  }
}
