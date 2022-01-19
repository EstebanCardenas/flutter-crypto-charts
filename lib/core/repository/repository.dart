library charts_core.repository;

import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../extension/extension.dart';
import 'package:charts/core/models/models.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Repository {
  static const String _baseUrl = 'https://api.coincap.io/v2';
  static final String _apiKey = dotenv.get('API_KEY');
  static final MapEntry<String, String> _authHeader =
      MapEntry('Authorization', 'Bearer $_apiKey');

  const Repository._();

  static Future<List<Asset>> getAssets({
    required int limit,
  }) async {
    try {
      Uri uri = Uri.parse('$_baseUrl/assets?limit=$limit');
      http.Response res = await http.get(
        uri,
        headers: Map.fromEntries([_authHeader]),
      );

      if (!res.ok()) {
        throw Exception('Failed to load the assets');
      }
      List<dynamic> data = jsonDecode(res.body)['data'];
      return List.generate(
        data.length,
        (int idx) => Asset.fromJson(data[idx]),
      );
    } catch (e, st) {
      debugPrint('Error: $e');
      debugPrint('StackTrace: $st');
      rethrow;
    }
  }

  static Future<List<Asset>> searchAssets({
    required String search,
  }) async {
    try {
      Uri uri = Uri.parse('$_baseUrl/assets?search=$search');
      http.Response res = await http.get(
        uri,
        headers: Map.fromEntries([_authHeader]),
      );

      if (!res.ok()) {
        throw Exception('Failed to load the assets');
      }
      List<dynamic> data = jsonDecode(res.body)['data'];
      return List.generate(
        data.length,
        (int idx) => Asset.fromJson(data[idx]),
      );
    } catch (e, st) {
      debugPrint('Error: $e');
      debugPrint('StackTrace: $st');
      rethrow;
    }
  }

  static Future<List<AssetHistoryInterval>> getAssetHistory({
    required String assetId,
    required String interval,
    DateTime? start,
  }) async {
    try {
      String url =
          '$_baseUrl/assets/${assetId.toLowerCase()}/history?interval=$interval';
      if (start != null) {
        url += '&start=${start.millisecondsSinceEpoch}';
        url += '&end=${DateTime.now().millisecondsSinceEpoch}';
      }
      Uri uri = Uri.parse(url);
      http.Response res = await http.get(
        uri,
        headers: Map.fromEntries([_authHeader]),
      );

      if (!res.ok()) {
        debugPrint('Bad Response: ${res.body}');
        throw Exception('Failed to load asset history');
      }
      List<dynamic> data = jsonDecode(res.body)['data'];
      return List.generate(
        data.length,
        (int idx) => AssetHistoryInterval.fromJson(data[idx]),
      );
    } catch (e, st) {
      debugPrint('Error: $e');
      debugPrint('StackTrace: $st');
      rethrow;
    }
  }
}
