part of charts_ui.widgets;

class AssetCard extends StatelessWidget {
  const AssetCard({
    Key? key,
    required this.asset,
    this.price,
  }) : super(key: key);

  final Asset asset;
  final num? price;

  String get _formattedPrice => price != null
      ? Utils.formatCurrency(price!.toDouble())
      : asset.formattedPrice;

  String formatChange(num change) =>
      (change > 0 ? '+' : '') + '${change.toStringAsFixed(4)}%';

  String get _formattedChange => price != null
      ? formatChange(asset.getNewChange(price!))
      : formatChange(asset.dayChange);

  Color get _cardColor {
    if (price != null ? asset.getNewChange(price!) > 0 : asset.dayChange > 0) {
      return Colors.green[300]!;
    } else if (price != null
        ? asset.getNewChange(price!) < 0
        : asset.dayChange < 0) {
      return Colors.red[400]!;
    } else {
      return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      elevation: 2,
      shadowColor: _cardColor,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: _cardColor)),
        ),
        child: InkWell(
          splashColor: Colors.black.withOpacity(0.1),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CryptoAssetView(
                asset,
                formattedPrice: _formattedPrice,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      asset.symbol,
                      style: TextStyles.title,
                    ),
                    Text(
                      _formattedPrice,
                      style: TextStyles.title,
                    )
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      asset.name,
                      style: TextStyles.paragraph,
                    ),
                    Text(
                      _formattedChange,
                      style: TextStyles.paragraph.copyWith(color: _cardColor),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
