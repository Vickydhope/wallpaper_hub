import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:wallpaper_hub/src/core/utils/errors/error_handler.dart';
import 'package:wallpaper_hub/src/core/utils/sealed/api_state.dart';

import '../../../../../core/resources/data_state.dart';
import '../../../domain/entity/photo_entity.dart';
import '../../../domain/usecases/search_photos.dart';

part 'search_photos_event.dart';

part 'search_photos_state.dart';

@injectable
class SearchPhotosBloc extends Bloc<SearchPhotosEvent, SearchPhotosState> {
  int _page = 0;
  final int _perPage = 20;
  bool _isLoading = false;
  final List<PhotoEntity> photos = [];
  final SearchPhotosUseCase _searchPhotosUseCase;

  SearchPhotosBloc(this._searchPhotosUseCase) : super(SearchPhotosState()) {
    on<SearchQueryChange>(
      (event, emit) {
        emit(state.copyWith(query: event.query));
      },
    );
    on<SearchPhotos>(_onSearchPhotosEvent);
  }

  FutureOr<void> _onSearchPhotosEvent(
      SearchPhotos event, Emitter<SearchPhotosState> emit) async {
    try {
      if (_isLoading && !event.refresh) return;
      _isLoading = true;

      if (event.refresh) {
        photos.clear();
        _page = 0;
      }
      _page++;

      emit(state.copyWith(apiState: LoadingState()));
      final dataState = await _searchPhotosUseCase(
        param: SearchPhotosParams(
          query: state.query,
          page: _page,
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
