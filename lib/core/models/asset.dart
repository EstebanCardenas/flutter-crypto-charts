part of charts_core.models;

class Asset {
  String id;
  int rank;
  String symbol;
  String name;
  num supply;
  num maxSupply;
  num marketCap;
  num volume;
  num priceUsd;
  num dayChange;

  num get originalPrice => priceUsd / ((dayChange / 100) + 1);

  String get formattedSupply => Utils.formatCurrency(supply.toDouble());
  String get formattedMaxSupply => Utils.formatCurrency(maxSupply.toDouble());
  String get formattedMarketCap => Utils.formatCurrency(marketCap.toDouble());
  String get formattedVolume => Utils.formatCurrency(volume.toDouble());
  String get formattedPrice => Utils.formatCurrency(priceUsd.toDouble());

  Asset._({
    required this.id,
    required this.rank,
    required this.symbol,
    required this.name,
    required this.supply,
    required this.maxSupply,
    required this.marketCap,
    required this.volume,
    required this.priceUsd,
    required this.dayChange,
  });

  factory Asset.fromJson(Map<String, dynamic> json) {
    return Asset._(
      id: json['id'] ?? 'id',
      rank: int.tryParse(json['rank'] ?? '') ?? 0,
      symbol: json['symbol'] ?? 'symbol',
      name: json['name'] ?? 'name',
      supply: num.tryParse(json['supply'] ?? '') ?? 0,
      maxSupply: num.tryParse(json['maxSupply'] ?? '') ?? 0,
      marketCap: num.tryParse(json['marketCapUsd'] ?? '') ?? 0,
      volume: num.tryParse(json['volumeUsd24Hr'] ?? '') ?? 0,
      priceUsd: num.tryParse(json['priceUsd'] ?? '') ?? 0,
      dayChange: num.tryParse(json['changePercent24Hr'] ?? '') ?? 0,
    );
  }

  num getNewChange(num newPrice) =>
      ((newPrice - originalPrice) / originalPrice) * 100;
}
