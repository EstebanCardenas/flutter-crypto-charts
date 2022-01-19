part of charts_core.models;

class AssetHistoryInterval {
  num price;
  DateTime time;

  AssetHistoryInterval._({
    required this.price,
    required this.time,
  });

  factory AssetHistoryInterval.fromJson(Map<String, dynamic> json) {
    return AssetHistoryInterval._(
      price: num.tryParse(json['priceUsd'] ?? '') ?? 0,
      time: json['time'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['time'])
          : DateTime.now(),
    );
  }

  @override
  String toString() => '{\n\tprice: $price\n\ttime: $time\n}';
}
