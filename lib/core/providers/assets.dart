part of charts_core.providers;

final assetsProvider = FutureProvider.autoDispose.family<List<Asset>, int>(
  (ref, limit) async {
    List<Asset> assets = await Repository.getAssets(limit: limit);
    return assets
        .where((asset) => asset.priceUsd.toStringAsFixed(2) != '1.00')
        .toList();
  },
);
