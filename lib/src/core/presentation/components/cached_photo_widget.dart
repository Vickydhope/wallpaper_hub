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
  });

  final double? height, width;
  final String? small;
  final String original;
  final Widget? placeholder;

  @override
  Widget build(BuildContext context) => CachedNetworkImage(
        imageUrl: original,
        fit: BoxFit.cover,
        fadeOutDuration: Duration.zero,
        width: width,
        height: height,
        fadeInDuration: Duration.zero,
        placeholderFadeInDuration: Duration.zero,
        placeholder: (context, url) =>
            placeholder ??
            (small == null
                ? const SizedBox()
                : CachedNetworkImage(
                    imageUrl: small!,
                    width: width,
                    height: height,
                    fit: BoxFit.cover,
                  )),
      );
}
