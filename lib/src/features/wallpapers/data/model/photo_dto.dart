import 'package:wallpaper_hub/src/core/utils/mapper/dto_mapper.dart';
import 'package:wallpaper_hub/src/features/wallpapers/data/model/src_dto.dart';
import 'package:wallpaper_hub/src/features/wallpapers/domain/entity/photo_entity.dart';

class PhotoDTO implements DtoMapper<PhotoEntity> {
  PhotoDTO({
    this.id,
    this.width,
    this.height,
    this.url,
    this.photographer,
    this.photographerUrl,
    this.photographerId,
    this.avgColor,
    this.src,
    this.liked,
    this.alt,
  });

  PhotoDTO.fromJson(dynamic json) {
    id = json['id'];
    width = json['width'];
    height = json['height'];
    url = json['url'];
    photographer = json['photographer'];
    photographerUrl = json['photographer_url'];
    photographerId = json['photographer_id'];
    avgColor = json['avg_color'];

    src = json['src'] != null ? SrcDTO.fromJson(json['src']) : null;
    liked = json['liked'];
    alt = json['alt'];
  }

  int? id;
  int? width;
  int? height;
  String? url;
  String? photographer;
  String? photographerUrl;
  int? photographerId;
  String? avgColor;
  SrcDTO? src;
  bool? liked;
  String? alt;

  PhotoDTO copyWith({
    int? id,
    int? width,
    int? height,
    String? url,
    String? photographer,
    String? photographerUrl,
    int? photographerId,
    String? avgColor,
    SrcDTO? src,
    bool? liked,
    String? alt,
  }) =>
      PhotoDTO(
        id: id ?? this.id,
        width: width ?? this.width,
        height: height ?? this.height,
        url: url ?? this.url,
        photographer: photographer ?? this.photographer,
        photographerUrl: photographerUrl ?? this.photographerUrl,
        photographerId: photographerId ?? this.photographerId,
        avgColor: avgColor ?? this.avgColor,
        src: src ?? this.src,
        liked: liked ?? this.liked,
        alt: alt ?? this.alt,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['width'] = width;
    map['height'] = height;
    map['url'] = url;
    map['photographer'] = photographer;
    map['photographer_url'] = photographerUrl;
    map['photographer_id'] = photographerId;
    map['avg_color'] = avgColor;
    if (src != null) {
      map['src'] = src?.toJson();
    }
    map['liked'] = liked;
    map['alt'] = alt;
    return map;
  }

  @override
  PhotoEntity toEntity() {
    return PhotoEntity(
        id: id ?? -1,
        url: url ?? '',
        photographer: photographer ?? '',
        photographer_url: photographerUrl ?? '',
        avg_color: avgColor ?? '',
        src: src?.toEntity() ?? SrcDTO().toEntity(),
        liked: liked ?? false,
        alt: alt ?? '');
  }
}
