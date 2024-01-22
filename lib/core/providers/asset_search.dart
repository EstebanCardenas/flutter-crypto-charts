part of charts_core.providers;

final assetSearchProvider =
    FutureProvider.autoDispose.family<List<Asset>, String>(
  (ref, search) async {
    ApiDataSource dataSource = ref.watch(apiDataSourceProvider);
    List<Asset> assets = await dataSource.searchAssets(search: search);
    return assets
        .where((asset) => asset.priceUsd.toStringAsFixed(2) != '1.00')
        .toList();
  },
);
