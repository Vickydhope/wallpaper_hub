import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallpaper_hub/src/core/resources/data_state.dart';
import 'package:wallpaper_hub/src/core/utils/errors/error_handler.dart';
import 'package:wallpaper_hub/src/core/utils/errors/failure.dart';
import 'package:wallpaper_hub/src/core/utils/sealed/api_state.dart';
import 'package:wallpaper_hub/src/features/wallpapers/domain/entity/photo_entity.dart';
import 'package:wallpaper_hub/src/features/wallpapers/domain/usecases/get_curated_photos.dart';

part 'curated_photos_event.dart';

part 'curated_photos_state.dart';

@injectable
class CuratedPhotosBloc extends Bloc<CuratedPhotosEvent, CuratedPhotosState> {
  final GetCuratedPhotosUseCase _getCuratedPhotosUseCase;
  int page = 0;
  final int _perPage = 20;
  bool _isLoading = false;

  final List<PhotoEntity> photos = [];

  CuratedPhotosBloc(this._getCuratedPhotosUseCase)
      : super(CuratedPhotosState()) {
    on<GetCuratedPhotosEvent>(_onGetCuratedPhotosEvent);
  }

  ///Fetch curated photos from Pexel Api
  FutureOr<void> _onGetCuratedPhotosEvent(event, emit) async {
    try {
      if (_isLoading && !event.refresh) return;
      _isLoading = true;

      if (event.refresh) {
        photos.clear();
        page = 0;
      }
      emit(state.copyWith(apiState: LoadingState()));
      page++;
      final dataState = await _getCuratedPhotosUseCase(
        param: GetCuratedPhotoParams(
          page: page,
          perPage: _perPage,
        ),
      );
      _isLoading = false;
      if (dataState is DataSuccess) {
        if (dataState.data == null) return;
        photos.addAll(dataState.data!);
        emit(
          state.copyWith(
            photos: photos,
            apiState: SuccessState(),
          ),
        );
      } else {
        emit(
          state.copyWith(
            apiState: ErrorState(message: dataState.error.toString()),
          ),
        );
      }
    } catch (error) {
      _isLoading = false;
      emit(
        state.copyWith(
          apiState: ErrorState(
              message: ErrorHandler.handle(error).failure.toString()),
        ),
      );
    }
  }
}
