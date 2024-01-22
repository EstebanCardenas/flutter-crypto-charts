part of charts_core.providers;

final assetHistoryStartDateProvider = StateProvider<DateTime>((ref) {
  return DateTime.now().subtract(const Duration(days: 30));
});
