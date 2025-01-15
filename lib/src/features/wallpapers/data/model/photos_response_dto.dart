import 'dart:convert';

import 'package:wallpaper_hub/src/features/wallpapers/data/model/photo_dto.dart';

class PhotosResponseDTO {
  PhotosResponseDTO({
    this.page,
    this.perPage,
    this.photos,
    this.totalResults,
    this.nextPage,
  });

  PhotosResponseDTO.fromJson(dynamic json) {


    page = json['page'];
    perPage = json['per_page'];
    if (json['photos'] != null) {
      photos = [];
      json['photos'].forEach((v) {
        photos?.add(PhotoDTO.fromJson(v));
      });
    }
    totalResults = json['total_results'];
    nextPage = json['next_page'];
  }

  int? page;
  int? perPage;
  List<PhotoDTO>? photos;
  int? totalResults;
  String? nextPage;

  PhotosResponseDTO copyWith({
    int? page,
    int? perPage,
    List<PhotoDTO>? photos,
    int? totalResults,
    String? nextPage,
  }) =>
      PhotosResponseDTO(
        page: page ?? this.page,
        perPage: perPage ?? this.perPage,
        photos: photos ?? this.photos,
        totalResults: totalResults ?? this.totalResults,
        nextPage: nextPage ?? this.nextPage,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['page'] = page;
    map['per_page'] = perPage;
    if (photos != null) {
      map['photos'] = photos?.map((v) => v.toJson()).toList();
    }
    map['total_results'] = totalResults;
    map['next_page'] = nextPage;
    return map;
  }
}