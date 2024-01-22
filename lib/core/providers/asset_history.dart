part of charts_core.providers;

final assetHistoryProvider =
    FutureProvider<List<AssetHistoryInterval>>((ref) async {
  ApiDataSource dataSource = ref.watch(apiDataSourceProvider);
  String? assetId = ref.watch(selectedAssetProvider);
  DateTime startDate = ref.watch(assetHistoryStartDateProvider);

  return assetId != null
      ? await dataSource.getAssetHistory(
          assetId: assetId,
          interval: 'd1',
          start: startDate,
        )
      : [];
});
