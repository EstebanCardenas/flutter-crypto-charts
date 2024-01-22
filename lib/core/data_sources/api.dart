library charts_core.repository;

import 'dart:convert';

import 'package:charts/core/constants.dart';
import 'package:flutter/cupertino.dart';

import '../extension/extension.dart';
import 'package:charts/core/models/models.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiDataSource {
  final String _apiKey = dotenv.get('API_KEY');
  late final Map<String, String> _headers = {
    'Authorization': 'Bearer $_apiKey',
  };

  ApiDataSource();

  Future<List<Asset>> getAssets({
    required int limit,
  }) async {
    try {
      Uri uri = Uri.parse('$baseUrl/assets?limit=$limit');
      http.Response res = await http.get(
        uri,
        headers: _headers,
      );

      if (!res.ok()) {
        throw Exception('Failed to load the assets');
      }
      List<dynamic> data = jsonDecode(res.body)['data'];

      return <Asset>[
        for (int i = 0; i < data.length; i++) Asset.fromJson(data[i]),
      ];
    } catch (e, st) {
      debugPrint('Error: $e');
      debugPrint('StackTrace: $st');
      rethrow;
    }
  }

  Future<List<Asset>> searchAssets({
    required String search,
  }) async {
    try {
      Uri uri = Uri.parse('$baseUrl/assets?search=$search');
      http.Response res = await http.get(
        uri,
        headers: _headers,
      );

      if (!res.ok()) {
        throw Exception('Failed to load the assets');
      }
      List<dynamic> data = jsonDecode(res.body)['data'];
      return <Asset>[
        for (int i = 0; i < data.length; i++) Asset.fromJson(data[i]),
      ];
    } catch (e, st) {
      debugPrint('Error: $e');
      debugPrint('StackTrace: $st');
      rethrow;
    }
  }

  Future<List<AssetHistoryInterval>> getAssetHistory({
    required String assetId,
    required String interval,
    DateTime? start,
  }) async {
    try {
      String url =
          '$baseUrl/assets/${assetId.toLowerCase()}/history?interval=$interval';
      if (start != null) {
        url += '&start=${start.millisecondsSinceEpoch}';
        url += '&end=${DateTime.now().millisecondsSinceEpoch}';
      }
      Uri uri = Uri.parse(url);
      http.Response res = await http.get(
        uri,
        headers: _headers,
      );

      if (!res.ok()) {
        debugPrint('Bad Response: ${res.body}');
        throw Exception('Failed to load asset history');
      }
      List<dynamic> data = jsonDecode(res.body)['data'];
      return <AssetHistoryInterval>[
        for (int i = 0; i < data.length; i++)
          AssetHistoryInterval.fromJson(data[i]),
      ];
    } catch (e, st) {
      debugPrint('Error: $e');
      debugPrint('StackTrace: $st');
      rethrow;
    }
  }
}
