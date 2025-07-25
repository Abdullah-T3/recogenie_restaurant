// To parse this JSON data, do
//
//     final errorResponseModel = errorResponseModelFromJson(jsonString);

import 'dart:convert';

ErrorResponseModel errorResponseModelFromJson(String str) => ErrorResponseModel.fromJson(json.decode(str));

String errorResponseModelToJson(ErrorResponseModel data) => json.encode(data.toJson());

class ErrorResponseModel {
  int? code;
  String? domain;
  String? message;
  int? status;
  dynamic formErrors;

  ErrorResponseModel({
    this.code,
    this.domain,
    this.message,
    this.status,
    this.formErrors,
  });

  factory ErrorResponseModel.fromJson(Map<String, dynamic> json) => ErrorResponseModel(
    code: json["code"],
    domain: json["domain"],
    message: json["message"],
    status: json["status"],
    formErrors: json["formErrors"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "domain": domain,
    "message": message,
    "status": status,
    "formErrors": formErrors,
  };
}
