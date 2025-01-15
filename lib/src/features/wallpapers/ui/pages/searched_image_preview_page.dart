import 'dart:core';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallpaper_hub/src/features/wallpapers/domain/entity/photo_entity.dart';
import 'package:wallpaper_hub/src/features/wallpapers/domain/entity/src_entity.dart';
import 'package:wallpaper_hub/src/features/wallpapers/ui/bloc/curated_photos/curated_photos_bloc.dart';
import 'package:wallpaper_hub/src/features/wallpapers/ui/bloc/search_photos/search_photos_bloc.dart';

class SearchedImagePreviewPage extends StatefulWidget {
  const SearchedImagePreviewPage({
    super.key,
    required this.index,
    required this.animation,
  });

  final int index;
  final Animation<double> animation;

  @override
  State<SearchedImagePreviewPage> createState() =>
      _SearchedImagePreviewPageState();
}

class _SearchedImagePreviewPageState extends State<SearchedImagePreviewPage> {
  late final PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    _currentIndex = widget.index;
    _pageController = PageController(initialPage: _currentIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SearchPhotosState state = context.watch<SearchPhotosBloc>().state;
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Container(
          margin: const EdgeInsets.only(left: 8),
          padding: Platform.isIOS ? const EdgeInsets.all(8) : EdgeInsets.zero,
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              shape: BoxShape.circle),
          child: const BackButton(),
        ).animate().slideX(delay: 150.ms, end: 0, begin: -2),
      ),
      body: Stack(
        children: [
          PageView.builder(
            physics: const ClampingScrollPhysics(),
            itemCount: state.photos.length,
            controller: _pageController,
            onPageChanged: (value) {
              var searchPhotosBloc = context.read<SearchPhotosBloc>();
              if (value == searchPhotosBloc.photos.length - 1) {
                searchPhotosBloc.add(SearchPhotos());
              }
              setState(() {
                _currentIndex = value;
              });
            },
            itemBuilder: (context, index) {
              final picture = state.photos[index];
              return ImageViewWidget(src: picture.src);
            },
          ),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: SafeArea(
              child: BottomActionBar(
                animation: widget.animation,
                currentPicture: state.photos[_currentIndex],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomActionBar extends StatefulWidget {
  final PhotoEntity currentPicture;

  const BottomActionBar({
    required this.animation,
    required this.currentPicture,
    super.key,
  });

  final Animation<double> animation;

  @override
  State<BottomActionBar> createState() => _BottomActionBarState();
}

class _BottomActionBarState extends State<BottomActionBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 50),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.share_rounded,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.download),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.favorite_outline_rounded),
          ),
          IconButton(
            onPressed: () {
              _openInfoBottomSheet(context, widget.currentPicture);
            },
            icon: const Icon(Icons.info_outline_rounded),
          ),
        ],
      ),
    ).animate().slideY(
          delay: 150.ms,
          begin: 3,
          end: 0,
          curve: Curves.easeInOutCubic,
        );
  }

  void _openInfoBottomSheet(BuildContext context, PhotoEntity picture) {
    const double borderRadius = 12;
    const double padding = 16;
    showModalBottomSheet(
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide.none,
      ),
      context: context,
      constraints: const BoxConstraints(maxWidth: 500, maxHeight: 300),
      builder: (context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(
            horizontal: borderRadius,
            vertical: borderRadius,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(borderRadius),
                    child: CachedNetworkImage(
                      imageUrl: picture.src.tiny,
                      fit: BoxFit.cover,
                      width: 100,
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Photo Details",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        Text("Photo Credit: ${picture.photographer}"),
                        picture.alt.isNotEmpty
                            ? Text("Info: ${picture.alt}")
                            : const SizedBox(),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class ImageViewWidget extends StatelessWidget {
  const ImageViewWidget({
    super.key,
    required this.src,
  });

  final SrcEntity src;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CachedNetworkImage(
        imageUrl: src.original,
        height: MediaQuery.of(context).size.height,
        fit: BoxFit.cover,
        fadeOutDuration: Duration.zero,
        fadeInDuration: Duration.zero,
        placeholderFadeInDuration: Duration.zero,
        placeholder: (context, url) => CachedNetworkImage(
          imageUrl: src.medium,
          height: MediaQuery.of(context).size.height,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _flightShuttleBuilder(
    flightContext,
    animation,
    flightDirection,
    fromHeroContext,
    toHeroContext,
  ) {
    Widget current;
    if (flightDirection == HeroFlightDirection.push) {
      current = toHeroContext.widget;
    } else {
      current = toHeroContext.widget;
    }
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final newValue = lerpDouble(0.0, 2 * pi, animation.value) ?? 0.0;

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.0015)
            ..rotateX(newValue),
          child: child,
        );
      },
      child: current,
    );
  }
}
