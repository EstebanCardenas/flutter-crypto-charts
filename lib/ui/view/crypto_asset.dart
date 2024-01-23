part of charts_ui.view;

class CryptoAssetView extends ConsumerStatefulWidget {
  const CryptoAssetView(
    this.asset, {
    Key? key,
  }) : super(key: key);

  final Asset asset;

  @override
  ConsumerState<CryptoAssetView> createState() => _CryptoAssetViewState();
}

class _CryptoAssetViewState extends ConsumerState<CryptoAssetView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(assetHistoryStartDateProvider.notifier).state =
          DateTime.now().subtract(const Duration(days: 30));
    });
  }

  @override
  Widget build(BuildContext context) {
    AsyncValue<List<AssetHistoryInterval>> assetHistory =
        ref.watch(assetHistoryProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: Navigator.of(context).pop,
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.asset.symbol.toUpperCase(),
              style: TextStyles.title.copyWith(color: Colors.white),
            ),
            Row(
              children: [
                Text(
                  widget.asset.name,
                  style: TextStyles.paragraph.copyWith(color: Colors.white54),
                ),
                const SizedBox(width: 4),
                Text(
                  '#${widget.asset.rank}',
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
              _PriceLabel(asset: widget.asset),
              const SizedBox(height: 32),
              _DataRow('Market Cap:', widget.asset.formattedMarketCap),
              _DataRow('Volume:', widget.asset.formattedVolume),
              _DataRow('Supply:', widget.asset.formattedSupply),
              const SizedBox(height: 16),
              TimeChipList(
                onChipTap: (duration) {
                  ref.read(assetHistoryStartDateProvider.notifier).state =
                      DateTime.now().subtract(duration);
                },
              ),
              const SizedBox(height: 12),
              assetHistory.when(
                data: (List<AssetHistoryInterval> data) => data.isEmpty
                    ? Center(
                        child: Text(
                          'No historic data found for ${widget.asset.symbol}',
                        ),
                      )
                    : AssetHistoryChart(intervals: data),
                error: (error, _) => Center(child: Text('$error')),
                loading: () => const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Center(
                    child: LinearProgressIndicator(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PriceLabel extends ConsumerWidget {
  const _PriceLabel({required this.asset});

  final Asset asset;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<Map<String, dynamic>> price =
        ref.watch(rtAssetsProvider(asset.id));

    return price.maybeWhen(
      data: (Map<String, dynamic> data) {
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
      orElse: () => Text(
        asset.formattedPrice,
        style: TextStyles.title.copyWith(
          color: Colors.black,
          fontSize: 32,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _DataRow extends StatelessWidget {
  const _DataRow(
    this.field,
    this.value, {
    Key? key,
  }) : super(key: key);

  final String field;
  final String value;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
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
