// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../core/data/interceptor/token_interceptor.dart' as _i646;
import '../../features/wallpapers/data/datasources/remote/wallpaper_api_service.dart'
    as _i720;
import '../../features/wallpapers/data/repositories/wallpaper_repository_impl.dart'
    as _i352;
import '../../features/wallpapers/domain/repository/wallpaper_repository.dart'
    as _i36;
import '../../features/wallpapers/domain/usecases/get_curated_photos.dart'
    as _i828;
import '../../features/wallpapers/domain/usecases/search_photos.dart' as _i462;
import '../../features/wallpapers/ui/bloc/curated_photos/curated_photos_bloc.dart'
    as _i921;
import '../../features/wallpapers/ui/bloc/download_photo/download_photo_bloc.dart'
    as _i776;
import '../../features/wallpapers/ui/bloc/search_photos/search_photos_bloc.dart'
    as _i443;
import 'app_module.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final appModule = _$AppModule();
    gh.factory<_i646.TokenInterceptor>(() => _i646.TokenInterceptor());
    gh.factory<_i776.DownloadPhotoBloc>(() => _i776.DownloadPhotoBloc());
    await gh.factoryAsync<_i361.Dio>(
      () => appModule.provideDio(gh<_i646.TokenInterceptor>()),
      preResolve: true,
    );
    gh.factory<_i720.WallpaperApiService>(
        () => _i720.WallpaperApiService(gh<_i361.Dio>()));
    gh.factory<_i36.WallpaperRepository>(
        () => _i352.WallpaperRepositoryImpl(gh<_i720.WallpaperApiService>()));
    gh.factory<_i462.SearchPhotosUseCase>(
        () => _i462.SearchPhotosUseCase(gh<_i36.WallpaperRepository>()));
    gh.factory<_i828.GetCuratedPhotosUseCase>(
        () => _i828.GetCuratedPhotosUseCase(gh<_i36.WallpaperRepository>()));
    gh.factory<_i443.SearchPhotosBloc>(
        () => _i443.SearchPhotosBloc(gh<_i462.SearchPhotosUseCase>()));
    gh.factory<_i921.CuratedPhotosBloc>(
        () => _i921.CuratedPhotosBloc(gh<_i828.GetCuratedPhotosUseCase>()));
    return this;
  }
}

class _$AppModule extends _i460.AppModule {}
