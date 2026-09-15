import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallpaper_hub/src/core/resources/data_state.dart';
import 'package:wallpaper_hub/src/core/utils/errors/error_handler.dart';
import 'package:wallpaper_hub/src/core/utils/sealed/request_state.dart';
import 'package:wallpaper_hub/src/features/wallpapers/domain/entity/photo_entity.dart';
import 'package:wallpaper_hub/src/features/wallpapers/domain/usecases/get_curated_photos.dart';

import '../../../domain/usecases/search_photos.dart';

part 'curated_photos_event.dart';

part 'curated_photos_state.dart';

@injectable
class CuratedPhotosBloc extends Bloc<CuratedPhotosEvent, CuratedPhotosState> {
  final GetCuratedPhotosUseCase _getCuratedPhotosUseCase;
  int page = 0;
  final int _perPage = 20;
  bool _isLoading = false;
  final List<PhotoEntity> photos = [];
  final SearchPhotosUseCase _searchPhotosUseCase;

  CuratedPhotosBloc(this._getCuratedPhotosUseCase, this._searchPhotosUseCase)
      : super(CuratedPhotosState()) {
    on<GetCuratedPhotosEvent>(
      (event, emit) => _fetch(
        refresh: event.refresh,
        emit: emit,
        request: () => _getCuratedPhotosUseCase(
          param: GetCuratedPhotoParams(page: page, perPage: _perPage),
        ),
      ),
    );
    on<SearchPhotosEvent>(
      (event, emit) => _fetch(
        refresh: event.refresh,
        emit: emit,
        request: () => _searchPhotosUseCase(
          param: SearchPhotosParams(
            query: state.query,
            page: page,
            perPage: _perPage,
          ),
        ),
      ),
    );

    on<SearchQueryChange>(
      (event, emit) {
        emit(state.copyWith(query: event.query));
      },
    );
  }

  /// Shared fetch/emit flow for both curated and search photo requests:
  /// guards against overlapping requests, resets pagination on refresh,
  /// appends results on success, and maps failures to an [ErrorState].
  FutureOr<void> _fetch({
    required bool refresh,
    required Emitter<CuratedPhotosState> emit,
    required Future<DataState<List<PhotoEntity>>> Function() request,
  }) async {
    try {
      if (_isLoading && !refresh) return;
      _isLoading = true;

      if (refresh) {
        photos.clear();
        page = 0;
      }
      emit(state.copyWith(apiState: LoadingState()));
      page++;
      final dataState = await request();
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
