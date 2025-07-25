import 'package:dio/dio.dart';

abstract class ApiCalls {
  Future<Response> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? header,
  });
  Future<Response> post(String endpoint, {Map<String, dynamic> body});
  Future<Response> put(String endpoint, Map<String, dynamic> body);
  Future<Response> delete(String endpoint);
}
