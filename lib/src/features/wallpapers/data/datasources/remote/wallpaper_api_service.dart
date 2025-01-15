import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:wallpaper_hub/src/config/base_url/base_url_config.dart';
import 'package:wallpaper_hub/src/features/wallpapers/data/model/photos_response_dto.dart';

part 'wallpaper_api_service.g.dart';

const String _apiCuratedPhotos = "${BaseUrlConfig.prefixImagesV1}/curated";
const String _apiSearchPhotos = "${BaseUrlConfig.prefixImagesV1}/search";

@RestApi()
@injectable
abstract class WallpaperApiService {

  @factoryMethod
  factory WallpaperApiService(Dio dio) => _WallpaperApiService(dio);

  @GET(_apiCuratedPhotos)
  Future<HttpResponse<PhotosResponseDTO>> getCuratedPhotos(
    @Query("page") int page,
    @Query("per_page") int perPage,
  );

  @GET(_apiSearchPhotos)
  Future<HttpResponse<PhotosResponseDTO>> searchPhotos(
    @Query("query") String query,
    @Query("page") int page,
    @Query("per_page") int perPage,
  );
}
