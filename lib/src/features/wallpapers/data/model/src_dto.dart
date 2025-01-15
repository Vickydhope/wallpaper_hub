import 'package:wallpaper_hub/src/core/utils/mapper/dto_mapper.dart';
import 'package:wallpaper_hub/src/features/wallpapers/domain/entity/src_entity.dart';

class SrcDTO implements DtoMapper<SrcEntity> {
  SrcDTO({
    this.original,
    this.large2x,
    this.large,
    this.medium,
    this.small,
    this.portrait,
    this.landscape,
    this.tiny,
  });

  SrcDTO.fromJson(dynamic json) {
    original = json['original'];
    large2x = json['large2x'];
    large = json['large'];
    medium = json['medium'];
    small = json['small'];
    portrait = json['portrait'];
    landscape = json['landscape'];
    tiny = json['tiny'];
  }

  String? original;
  String? large2x;
  String? large;
  String? medium;
  String? small;
  String? portrait;
  String? landscape;
  String? tiny;

  SrcDTO copyWith({
    String? original,
    String? large2x,
    String? large,
    String? medium,
    String? small,
    String? portrait,
    String? landscape,
    String? tiny,
  }) =>
      SrcDTO(
        original: original ?? this.original,
        large2x: large2x ?? this.large2x,
        large: large ?? this.large,
        medium: medium ?? this.medium,
        small: small ?? this.small,
        portrait: portrait ?? this.portrait,
        landscape: landscape ?? this.landscape,
        tiny: tiny ?? this.tiny,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['original'] = original;
    map['large2x'] = large2x;
    map['large'] = large;
    map['medium'] = medium;
    map['small'] = small;
    map['portrait'] = portrait;
    map['landscape'] = landscape;
    map['tiny'] = tiny;
    return map;
  }

  @override
  SrcEntity toEntity() {
    return SrcEntity(
      original: original ?? '',
      large: large ?? '',
      large2x: large2x ?? '',
      medium: medium ?? '',
      small: small ?? '',
      tiny: tiny ?? '',
      portrait: portrait ?? '',
      landscape: landscape ?? '',
    );
  }
}
