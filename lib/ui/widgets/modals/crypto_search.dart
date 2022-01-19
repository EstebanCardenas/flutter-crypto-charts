part of charts_ui.view.modals;

class CryptoSearchModal extends StatelessWidget {
  const CryptoSearchModal({
    Key? key,
    required this.controller,
    required this.onSearch,
  }) : super(key: key);

  final TextEditingController controller;
  final void Function() onSearch;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, BoxConstraints constraints) => AlertDialog(
        alignment: Alignment.center,
        title: const Center(child: Text('Seach Asset')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: constraints.maxWidth,
              child: TextFormField(
                controller: controller,
                decoration: const InputDecoration(
                  helperText:
                      'Search for crypto by symbol\n(ex: BTC, ETH, XRP)',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onSearch();
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.black,
              fixedSize: Size.fromWidth(constraints.maxWidth / 3),
            ),
            child: const Text(
              'Search',
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