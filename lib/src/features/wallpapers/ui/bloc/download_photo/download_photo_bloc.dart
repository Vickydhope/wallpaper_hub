import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:wallpaper_hub/src/core/utils/sealed/download_state.dart';

part 'download_photo_event.dart';

part 'download_photo_state.dart';

@injectable
class DownloadPhotoBloc extends Bloc<DownloadPhotoEvent, DownloadPhotoState> {
  DownloadPhotoBloc() : super(DownloadPhotoState()) {
    on<DownloadPhoto>(_onDownloadPhoto);
  }

  FutureOr<void> _onDownloadPhoto(
      DownloadPhoto event, Emitter<DownloadPhotoState> emit) async {
    emit(state.copyWith(downloadState: LoadingState()));

    emit(state.copyWith(downloadState: SuccessState()));
  }
}
