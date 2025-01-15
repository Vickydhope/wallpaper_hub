// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:wallpaper_hub/src/features/wallpapers/domain/entity/src_entity.dart';

class PhotoEntity extends Equatable {
  final int id;
  final String url;
  final String photographer;
  final String photographer_url;
  final String avg_color;
  final SrcEntity src;
  final bool liked;
  final String alt;

  const PhotoEntity({
    required this.id,
    required this.url,
    required this.photographer,
    required this.photographer_url,
    required this.avg_color,
    required this.src,
    required this.liked,
    required this.alt,
  });

  @override
  List<Object?> get props =>
      [id, url, photographer, photographer_url, avg_color, src, liked, alt];
}
