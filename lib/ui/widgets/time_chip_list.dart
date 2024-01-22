part of charts_ui.widgets;

class TimeChipList extends StatefulWidget {
  const TimeChipList({
    Key? key,
    required this.onChipTap,
  }) : super(key: key);

  final void Function(Duration duration) onChipTap;

  @override
  _TimeChipListState createState() => _TimeChipListState();
}

class _TimeChipListState extends State<TimeChipList> {
  int selectedIdx = 0;

  List<Duration> get durations => const [
        Duration(days: 30),
        Duration(days: 90),
        Duration(days: 180),
        Duration(days: 365),
        Duration(days: 1825),
      ];

  List<String> get durationLabels => const [
        '1M',
        '3M',
        '6M',
        '1Y',
        '5Y',
      ];

  int get length => durations.length;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: length,
        itemBuilder: (_, int i) => TimeChip(
          selected: i == selectedIdx,
          label: durationLabels[i],
          onSelected: () {
            setState(() {
              selectedIdx = i;
            });
            widget.onChipTap(durations[i]);
          },
        ),
        separatorBuilder: (_, __) => const SizedBox(width: 4),
      ),
    );
  }
}

class TimeChip extends StatelessWidget {
  const TimeChip({
    Key? key,
    required this.label,
    required this.onSelected,
    this.selected = false,
  }) : super(key: key);

  final String label;
  final void Function() onSelected;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      selected: selected,
      backgroundColor: Colors.black,
      label: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.black : Colors.white,
        ),
      ),
      onSelected: (_) => onSelected(),
    );
  }
}
