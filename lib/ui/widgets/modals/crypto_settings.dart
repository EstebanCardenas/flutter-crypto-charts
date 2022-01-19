part of charts_ui.view.modals;

class CryptoSettingsModal extends StatefulWidget {
  const CryptoSettingsModal({
    Key? key,
    required this.assetLimit,
    required this.onSave,
  }) : super(key: key);

  final double assetLimit;
  final void Function(int value) onSave;

  @override
  _CryptoSettingsModalState createState() => _CryptoSettingsModalState();
}

class _CryptoSettingsModalState extends State<CryptoSettingsModal> {
  late double _newLimit;

  @override
  void initState() {
    super.initState();
    _newLimit = widget.assetLimit;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, BoxConstraints constraints) => AlertDialog(
        alignment: Alignment.center,
        title: const Center(child: Text('Settings')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Asset Limit',
              style: TextStyles.title.copyWith(color: Colors.black),
            ),
            Slider(
              value: _newLimit,
              min: 5,
              max: 25,
              divisions: 20,
              label: _newLimit.round().toString(),
              onChanged: (value) {
                setState(() {
                  _newLimit = value;
                });
              },
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.spaceAround,
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onSave(_newLimit.toInt());
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.black,
              fixedSize: Size.fromWidth(constraints.maxWidth / 3),
            ),
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
          ),
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              primary: Colors.white,
              shadowColor: Colors.black,
              fixedSize: Size.fromWidth(constraints.maxWidth / 3),
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
