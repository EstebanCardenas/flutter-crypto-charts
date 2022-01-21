part of charts_ui.view;

class CryptoAssetView extends ConsumerStatefulWidget {
  const CryptoAssetView(
    this.asset, {
    Key? key,
  }) : super(key: key);

  final Asset asset;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CryptoAssetViewState();
}

class _CryptoAssetViewState extends ConsumerState<CryptoAssetView> {
  late Asset asset;
  Duration chartDuration = const Duration(days: 30);

  @override
  void initState() {
    asset = widget.asset;
    super.initState();
  }

  Widget dataRow(
    String field,
    String value,
  ) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              field,
              style: TextStyles.paragraph.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 16,
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
      start: DateTime.now().subtract(chartDuration),
    );
  }

  @override
  Widget build(BuildContext context) {
    String assetNames = ref.watch(selectedAssetNames);
    AsyncValue<Map<String, dynamic>> prices =
        ref.watch(rtAssetsProvider(assetNames));
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
              prices.when(
                data: (data) {
                  return Text(
                    Utils.formatCurrency(
                      num.tryParse(data[asset.id] ?? '')?.toDouble() ??
                          asset.priceUsd.toDouble(),
                    ),
                    style: TextStyles.title.copyWith(
                      color: Colors.black,
                      fontSize: 32,
                    ),
                    textAlign: TextAlign.center,
                  );
                },
                error: (_, __) => Text(
                  asset.formattedPrice,
                  style: TextStyles.title.copyWith(
                    color: Colors.black,
                    fontSize: 32,
                  ),
                  textAlign: TextAlign.center,
                ),
                loading: () => const LinearProgressIndicator(minHeight: 16),
              ),
              const SizedBox(height: 32),
              dataRow('Market Cap:', asset.formattedMarketCap),
              dataRow('Volume:', asset.formattedVolume),
              dataRow('Supply:', asset.formattedSupply),
              const SizedBox(height: 16),
              TimeChipList(
                onChipTap: (duration) => setState(() {
                  chartDuration = duration;
                }),
              ),
              const SizedBox(height: 12),
              FutureBuilder(
                future: assetHistory,
                builder: (
                  _,
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
                    widget = const Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Center(
                        child: LinearProgressIndicator(),
                      ),
                    );
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
