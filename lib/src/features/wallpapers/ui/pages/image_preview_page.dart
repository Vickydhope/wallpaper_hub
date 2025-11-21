import 'dart:core';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallpaper_hub/src/core/presentation/components/cached_photo_widget.dart';
import 'package:wallpaper_hub/src/core/utils/sealed/download_state.dart';
import 'package:wallpaper_hub/src/features/wallpapers/domain/entity/photo_entity.dart';
import 'package:wallpaper_hub/src/features/wallpapers/domain/entity/src_entity.dart';
import 'package:wallpaper_hub/src/features/wallpapers/ui/bloc/curated_photos/curated_photos_bloc.dart';
import 'package:wallpaper_hub/src/features/wallpapers/ui/widgets/bottom_action_bar.dart';

class ImagePreviewPage extends StatefulWidget {
  const ImagePreviewPage({
    super.key,
    required this.index,
    required this.animation,
  });

  final int index;
  final Animation<double> animation;

  @override
  State<ImagePreviewPage> createState() => _ImagePreviewPageState();
}

class _ImagePreviewPageState extends State<ImagePreviewPage> {
  late final PageController _pageController;
  late int _currentIndex;
  bool showOriginal = false;
  double pageOffset = 0;

  @override
  void initState() {
    _currentIndex = widget.index;
    pageOffset = _currentIndex.toDouble();
    _pageController = PageController(initialPage: _currentIndex);

    _pageController.addListener(
      () {
        setState(() => pageOffset =
            _pageController.page ?? 0); //<-- add listener and set state
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CuratedPhotosState curatedPhotosState =
        context.watch<CuratedPhotosBloc>().state;
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () => setState(() => showOriginal = !showOriginal),
              icon: Icon(
                showOriginal ? Icons.fullscreen : Icons.fullscreen_exit,
                color:
                    showOriginal ? Colors.grey.shade700 : Colors.grey.shade300,
              ))
        ],
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
            itemCount: curatedPhotosState.photos.length + 1,
            controller: _pageController,
            onPageChanged: (value) {
              var curatedBloc = context.read<CuratedPhotosBloc>();
              if (value == curatedPhotosState.photos.length - 1) {
                curatedBloc.add(GetCuratedPhotosEvent());
              }
              setState(() {
                _currentIndex = value;
              });
            },
            itemBuilder: (context, index) {
              if (index == curatedPhotosState.photos.length) {
                return const Center(child: CircularProgressIndicator());
              }
              final picture = curatedPhotosState.photos[index];
              return InteractiveImageView(
                  showOriginal: showOriginal,
                  offset: pageOffset - index,
                  picture: picture);
            },
          ),
          if (_currentIndex < curatedPhotosState.photos.length)
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: SafeArea(
                child: BottomActionBar(
                  animation: widget.animation,
                  currentPicture: curatedPhotosState.photos[_currentIndex],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class InteractiveImageView extends StatefulWidget {
  const InteractiveImageView({
    super.key,
    required this.showOriginal,
    required this.offset,
    required this.picture,
  });

  final bool showOriginal;
  final double offset;
  final PhotoEntity picture;

  @override
  State<InteractiveImageView> createState() => _InteractiveImageViewState();
}

class _InteractiveImageViewState extends State<InteractiveImageView>
  {


  @override
  void initState() {
    super.initState();


  }

  @override
  void dispose() {

    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.maxFinite,
      width: double.maxFinite,
      child: AnimatedSwitcher(
        duration: 300.ms,
        child: widget.showOriginal
            ? CachedPhotoWidget(
                key: const Key("Contain"),
                boxFit: BoxFit.contain,
                offset: widget.offset,
                original: widget.picture.src.original,
                small: widget.picture.src.medium,
                width: double.maxFinite,
              )
            : CachedPhotoWidget(
                height: double.maxFinite,
                width: double.maxFinite,
                key: const Key("Cover"),
                boxFit: BoxFit.cover,
                offset: widget.offset,
                original: widget.picture.src.original,
                small: widget.picture.src.medium,
              ),
      ),
    );
  }
}
