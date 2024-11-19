import 'dart:convert';
import 'package:dio/dio.dart';

class HttpClient {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: "https://trailsync-h4cpdje8dza6esed.brazilsouth-01.azurewebsites.net/api/v1/"),
  );

  Future<Response> getRequest(String path) async {
    try {
      return await _dio.get(path);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> postRequest(String path, Map<String, dynamic> data) async {
    try {
      return await _dio.post(path, data: jsonEncode(data));
    } catch (e) {
      rethrow;
    }
  }
}