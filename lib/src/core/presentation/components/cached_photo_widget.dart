import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedPhotoWidget extends StatelessWidget {
  const CachedPhotoWidget({
    super.key,
    this.small,
    required this.original,
    this.height,
    this.width,
    this.placeholder,
    this.offset = 0,
    this.boxFit = BoxFit.cover,
  });

  final double? height, width;
  final String? small;
  final String original;
  final Widget? placeholder;
  final double offset;
  final BoxFit boxFit;

  @override
  Widget build(BuildContext context) => CachedNetworkImage(
        imageUrl: original,
        fit: boxFit,
        fadeOutDuration: Duration.zero,
        width: width,
        height: height,
        alignment: Alignment(offset, 0),
        fadeInDuration: Duration.zero,
        placeholderFadeInDuration: Duration.zero,
        placeholder: (context, url) =>
            placeholder ??
            (small == null
                ? const SizedBox()
                : CachedNetworkImage(
                    alignment: Alignment(offset, 0),
                    imageUrl: small!,
                    width: width,
                    height: height,
                    fit: boxFit,
                  )),
      );
}
