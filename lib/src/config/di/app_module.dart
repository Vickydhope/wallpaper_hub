import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';
import 'package:wallpaper_hub/src/config/base_url/base_url_config.dart';

import '../../core/data/interceptor/token_interceptor.dart';

@module
abstract class AppModule {
  @preResolve
  Future<Dio> provideDio(
    TokenInterceptor tokenInterceptor,
  ) async {
    return Dio(
      BaseOptions(baseUrl: BaseUrlConfig.baseUrl),
    )..interceptors.addAll(
        [
          tokenInterceptor,
          LogInterceptor(
            request: true,
            requestBody: true,
            responseHeader: true,
            responseBody: true,
            requestHeader: true,
          ),
        ],
      );
  }
}
