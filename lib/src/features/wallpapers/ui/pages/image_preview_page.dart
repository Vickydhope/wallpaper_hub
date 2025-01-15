import 'dart:core';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallpaper_hub/src/core/presentation/components/cached_photo_widget.dart';
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

  @override
  void initState() {
    _currentIndex = widget.index;
    _pageController = PageController(initialPage: _currentIndex);
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
            itemCount: curatedPhotosState.photos.length,
            controller: _pageController,
            onPageChanged: (value) {
              var curatedBloc = context.read<CuratedPhotosBloc>();
              if (value == curatedBloc.photos.length - 1) {
                curatedBloc.add(GetCuratedPhotosEvent());
              }
              setState(() {
                _currentIndex = value;
              });
            },
            itemBuilder: (context, index) {
              final picture = curatedPhotosState.photos[index];
              return CachedPhotoWidget(
                original: picture.src.original,
                small: picture.src.medium,
              );
            },
          ),


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
