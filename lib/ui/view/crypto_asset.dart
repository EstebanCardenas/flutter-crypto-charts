part of charts_ui.view;

class CryptoAssetView extends ConsumerWidget {
  const CryptoAssetView(
    this.asset, {
    Key? key,
  }) : super(key: key);

  final Asset asset;

  Widget dataRow(
    String field,
    String value,
  ) {
    double fontSize = 16;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              field,
              style: TextStyles.paragraph.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: fontSize,
                color: Colors.black,
              ),
            ),
            Text(value),
          ],
        ),
        const Divider(color: Colors.black),
      ],
    );
  }

  Future<List<AssetHistoryInterval>> get assetHistory {
    return Repository.getAssetHistory(
      assetId: asset.id,
      interval: 'd1',
      start: DateTime.now().subtract(const Duration(days: 30)),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              asset.symbol.toUpperCase(),
              style: TextStyles.title.copyWith(color: Colors.white),
            ),
            Row(
              children: [
                Text(
                  asset.name,
                  style: TextStyles.paragraph.copyWith(color: Colors.white54),
                ),
                const SizedBox(width: 4),
                Text(
                  '#${asset.rank}',
                  style: TextStyles.paragraph.copyWith(color: Colors.white54),
                ),
              ],
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
              Text(
                asset.formattedPrice,
                style: TextStyles.title.copyWith(
                  color: Colors.black,
                  fontSize: 32,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              dataRow('Market Cap:', asset.formattedMarketCap),
              dataRow('Volume:', asset.formattedVolume),
              dataRow('Supply:', asset.formattedSupply),
              const SizedBox(height: 32),
              FutureBuilder(
                future: assetHistory,
                builder: (
                  BuildContext context,
                  AsyncSnapshot snapshot,
                ) {
                  late Widget widget;
                  if (snapshot.hasData) {
                    List<AssetHistoryInterval> assetHistory = snapshot.data;
                    if (assetHistory.isEmpty) {
                      widget = Center(
                        child: Text(
                          'No historic data found for ${asset.symbol}',
                        ),
                      );
                    } else {
                      widget = AssetHistoryChart(intervals: assetHistory);
                    }
                  } else if (snapshot.hasError) {
                    widget = Center(child: Text(snapshot.error.toString()));
                  } else {
                    widget = const Center(child: CircularProgressIndicator());
                  }
                  return widget;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
