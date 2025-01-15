import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:wallpaper_hub/src/core/constants.dart';
@injectable
class TokenInterceptor extends Interceptor {


  TokenInterceptor();

  @override
  Future onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Here you can put the token, either from preference, sqlite, etc.
    // Here is an example with Preferences

    // After you choose your token, you assign it to the request.
    options.headers['Authorization'] = AppConstants.pixelApiKey;

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Do something with response data
    super.onResponse(response, handler);
  }

  @override
  Future onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
/*    // If the error is 401 Unauthorized, log out the user
    if (err.response?.statusCode == 401) {
      _repository.logOut();
      _appDatabase.userDao.deleteAllUsers();
    }*/
    super.onError(err, handler);
  }
}
