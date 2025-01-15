import 'package:dio/dio.dart';

import 'failure.dart';

class ErrorHandler implements Exception {
  late Failure failure;

  ErrorHandler.handle(dynamic error) {
    if (error is DioException) {
      // dio error so its an error from response of the API or from dio itself
      failure = _handleError(error);
    } else {
      // default error
      failure = DataSource.DEFAULT.getFailure();
    }
  }
}

Failure _handleError(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
      return DataSource.CONNECT_TIMEOUT.getFailure();
    case DioExceptionType.connectionError:
      return DataSource.NO_INTERNET_CONNECTION.getFailure();
    case DioExceptionType.sendTimeout:
      return DataSource.SEND_TIMEOUT.getFailure();
    case DioExceptionType.receiveTimeout:
      return DataSource.RECIEVE_TIMEOUT.getFailure();
    case DioExceptionType.badResponse:
      if (error.response?.statusCode == ResponseCode.UNAUTORISED) {
        return DataSource.UNAUTORISED.getFailure();
      }
      if (error.response?.statusCode == ResponseCode.BAD_REQUEST) {
        return DataSource.BAD_REQUEST.getFailure();
      }

      if (error.response?.statusCode == ResponseCode.ENTITY_TOO_LARGE) {

        return DataSource.ENTITY_TOO_LARGE.getFailure();
      }

      if (error.response?.statusCode == 400) {
        if (error.response != null) {
          var response = error.response?.data.toString() ?? '';

          return DataSource.DEFAULT.getFailure(
              message: response == "Invalid Promo Code"
                  ? "Event code already exist with another event.\nPlease enter a new event code."
                  : response);
        }

        return DataSource.BAD_RESPONSE.getFailure();
      }
      if (error.response != null &&
          error.response?.statusCode != null &&
          error.response?.statusMessage != null) {
        return Failure(
          error.response?.statusCode ?? 0,
          error.message ?? DataSource.BAD_REQUEST.getFailure().toString(),
        );
      } else {
        return DataSource.DEFAULT.getFailure();
      }
    case DioExceptionType.cancel:
      return DataSource.CANCEL.getFailure();
    default:
      return DataSource.DEFAULT.getFailure();
  }
}

enum DataSource {
  SUCCESS,
  NO_CONTENT,
  BAD_REQUEST,
  BAD_RESPONSE,
  FORBIDDEN,
  UNAUTORISED,
  NOT_FOUND,
  INTERNAL_SERVER_ERROR,
  CONNECT_TIMEOUT,
  CANCEL,
  RECIEVE_TIMEOUT,
  SEND_TIMEOUT,
  CACHE_ERROR,
  NO_INTERNET_CONNECTION,
  ENTITY_TOO_LARGE,
  DEFAULT
}

extension DataSourceExtension on DataSource {
  Failure getFailure({String? message}) {
    switch (this) {
      case DataSource.SUCCESS:
        return Failure(ResponseCode.SUCCESS, "");
      case DataSource.NO_CONTENT:
        return Failure(ResponseCode.NO_CONTENT, "No Records Found");
      case DataSource.BAD_REQUEST:
        return Failure(
            ResponseCode.BAD_REQUEST, "Bad request. try again later");
      case DataSource.BAD_RESPONSE:
        return Failure(
            ResponseCode.BAD_RESPONSE, "Bad response. try again later");
      case DataSource.FORBIDDEN:
        return Failure(
            ResponseCode.FORBIDDEN, "Forbidden request. try again later");
      case DataSource.UNAUTORISED:
        return Failure(
            ResponseCode.UNAUTORISED, "User is unauthorized, try again later");
      case DataSource.NOT_FOUND:
        return Failure(
            ResponseCode.NOT_FOUND, "Url not found, try again later");

      case DataSource.INTERNAL_SERVER_ERROR:
        return Failure(ResponseCode.INTERNAL_SERVER_ERROR,
            "Something went wrong, try again later");
      case DataSource.CONNECT_TIMEOUT:
        return Failure(
            ResponseCode.CONNECT_TIMEOUT, "Time out, try again later");
      case DataSource.CANCEL:
        return Failure(ResponseCode.CANCEL, "Request cancelled by user.");
      case DataSource.RECIEVE_TIMEOUT:
        return Failure(
            ResponseCode.RECIEVE_TIMEOUT, "time out, try again late");
      case DataSource.SEND_TIMEOUT:
        return Failure(ResponseCode.SEND_TIMEOUT, "time out, try again late");
      case DataSource.CACHE_ERROR:
        return Failure(
            ResponseCode.CACHE_ERROR, "Cache error, try again later");
      case DataSource.NO_INTERNET_CONNECTION:
        return Failure(ResponseCode.NO_INTERNET_CONNECTION,
            "Please check your internet connection");
      case DataSource.ENTITY_TOO_LARGE:
        print(DataSource.ENTITY_TOO_LARGE.toString());
        return Failure(
          ResponseCode.ENTITY_TOO_LARGE,
          "Up to 50 MB of photos or videos can be uploaded in a single request.",
        );
      case DataSource.DEFAULT:
        return Failure(
          ResponseCode.DEFAULT,
          message ?? "Something went wrong, try again later",
        );
    }
  }
}

class ResponseCode {
  static const int SUCCESS = 200; // success with data
  static const int NO_CONTENT = 201; // success with no data (no content)
  static const int BAD_REQUEST = 400; // failure, API rejected request
  static const int BAD_RESPONSE = 400; // failure, API rejected request
  static const int UNAUTORISED = 401; // failure, user is not authorised
  static const int FORBIDDEN = 403; //  failure, API rejected request
  static const int INTERNAL_SERVER_ERROR = 500; // failure, crash in server side
  static const int NOT_FOUND = 404; // failure, not found
  static const int ENTITY_TOO_LARGE = 413; // failure, not found

  // local status code
  static const int CONNECT_TIMEOUT = -1;
  static const int CANCEL = -2;
  static const int RECIEVE_TIMEOUT = -3;
  static const int SEND_TIMEOUT = -4;
  static const int CACHE_ERROR = -5;
  static const int NO_INTERNET_CONNECTION = -6;
  static const int DEFAULT = -7;
}

class ApiInternalStatus {
  static const int SUCCESS = 200;
  static const int FAILURE = 400;
}
