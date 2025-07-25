import 'package:dio/dio.dart';
import 'package:recogenie_restaurant/core/error/errorResponseModel.dart';

class DioExceptionHandler {
  static ErrorResponseModel handleError(DioException error) {
    // switch (error.type) {
    //   case DioExceptionType.connectionTimeout:
    //     return _handleResponseError(error);
    //
    //   case DioExceptionType.sendTimeout:
    //     return _handleResponseError(error);
    //
    //   case DioExceptionType.receiveTimeout:
    //     return _handleResponseError(error);
    //
    //   case DioExceptionType.badCertificate:
    //     return _handleResponseError(error);
    //
    //   case DioExceptionType.badResponse:
    //     return _handleResponseError(error);
    //   case DioExceptionType.cancel:
    //     return _handleResponseError(error);
    //
    //   case DioExceptionType.connectionError:
    //     return _handleResponseError(error);
    //
    //   case DioExceptionType.unknown:
    //     return _handleResponseError(error);
    // }
    return _handleResponseError(error);
  }

  static ErrorResponseModel _handleResponseError(DioException error) {
    final statusCode = error.response?.statusCode;
    // switch (statusCode) {
    //   case 400:
    //     return ErrorResponseModel(
    //       code: 400,
    //       domain: error.response?.data['domain'],
    //       message: error.response?.data['message'],
    //       status: error.response?.data['status'],
    //       formErrors: error.response?.data['formErrors'],
    //     );
    //   case 401:
    //     return 'Unauthorized';
    //   case 403:
    //     return 'Forbidden';
    //   case 404:
    //     return 'Not found';
    //   case 500:
    //     return 'Internal server error';
    //   default:
    //     return ErrorResponseModel();
    // }
    return ErrorResponseModel(
      code: statusCode,
      domain: error.response?.data['domain'],
      message: error.response?.data['message'],
      status: error.response?.data['status'],
      formErrors: error.response?.data['formErrors'],
    );
  }
}
