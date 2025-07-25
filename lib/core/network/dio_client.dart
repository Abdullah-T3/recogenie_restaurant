// core/network/dio_client.dart

import 'package:dio/dio.dart';

import '../error/dio_exception_handler.dart';
import '../error/failure.dart';
import '../helper/Connectivity/connectivity_helper.dart';
import 'ApiCalls.dart';

class DioClient implements ApiCalls {
  late final Dio dio;
  String baseUrl;

  DioClient({required this.baseUrl}) {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.add(
      LogInterceptor(
        request: true,
        error: true,
        requestBody: true,
        requestHeader: true,
        responseBody: true,
        responseHeader: true,
      ),
    );
  }

  @override
  Future<Response> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? header,
  }) async {
    final isConnected = await ConnectivityHelper.isConnected();
    if (isConnected) {
      try {
        final response = await dio.get(
          url,
          queryParameters: queryParameters,
          options: Options(headers: header),
        );

        return response;
      } on DioException catch (e) {
        throw DioExceptionHandler.handleError(e);
      }
    } else {
      throw Failure('No internet connection', FailureType.connection);
    }
  }

  @override
  Future<Response> post(
    String url, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? header,
  }) async {
    final isConnected = await ConnectivityHelper.isConnected();
    if (isConnected) {
      try {
        final response = await dio.post(
          url,
          data: body,
          options: Options(headers: header),
        );

        return response;
      } on DioException catch (e) {
        throw DioExceptionHandler.handleError(e);
      }
    } else {
      throw Failure('No internet connection', FailureType.connection);
    }
  }

  @override
  Future<Response> put(
    String url,
    Map<String, dynamic>? body, {
    Map<String, dynamic>? header,
  }) async {
    final isConnected = await ConnectivityHelper.isConnected();
    if (isConnected) {
      try {
        final response = await dio.put(
          url,
          data: body,
          options: Options(headers: header),
        );

        return response;
      } on DioException catch (e) {
        throw DioExceptionHandler.handleError(e);
      }
    } else {
      throw Failure('No internet connection', FailureType.connection);
    }
  }

  @override
  Future<Response> delete(String url, {Map<String, dynamic>? header}) async {
    final isConnected = await ConnectivityHelper.isConnected();
    if (isConnected) {
      try {
        final response = await dio.request(
          url,
          options: Options(headers: header, method: 'DELETE'),
        );

        return response;
      } on DioException catch (e) {
        throw DioExceptionHandler.handleError(e);
      }
    } else {
      throw Failure('No internet connection', FailureType.connection);
    }
  }

  // Map<String, dynamic> _validateResponseData(Response response) {
  //   if (response.statusCode == 204 ||
  //       response.statusCode == 201 ||
  //       response.statusCode == 200) {
  //     if (response.data == null || response.data.toString().isEmpty) {
  //       return {'statusCode': response.statusCode};
  //     }
  //   }
  //   if (response.data is Map<String, dynamic>) {
  //     return response.data;
  //   } else if (response.data != null) {
  //     return {'data': response.data};
  //   } else {
  //     throw Exception(
  //       'Invalid response format: Expected Map<String, dynamic>, but got ${response.runtimeType}',
  //     );
  //   }
  // }
}
