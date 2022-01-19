part of charts_core.providers;

final rtAssetsProvider =
    StreamProvider.autoDispose.family<Map<String, dynamic>, String?>(
  (ref, assets) async* {
    final Map<String, dynamic> rtAssets = {};
    final IOWebSocketChannel channel =
        IOWebSocketChannel.connect('wss://ws.coincap.io/prices?assets=$assets');

    ref.onDispose(() => channel.sink.close());

    await for (final value in channel.stream) {
      Map<String, dynamic> assetData = jsonDecode(value);
      rtAssets.addAll(assetData);
      yield rtAssets;
    }
  },
);
