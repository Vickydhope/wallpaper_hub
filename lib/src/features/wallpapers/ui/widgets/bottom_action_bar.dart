import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:wallpaper_hub/src/features/wallpapers/domain/entity/photo_entity.dart';
import 'package:path_provider/path_provider.dart';

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
  void initState() {
    _prepareSaveDir();
    super.initState();
  }
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
            onPressed: () async {

              print("SaveLocation : $_localPath");
              final taskId = await FlutterDownloader.enqueue(
                url: widget.currentPicture.src.original,
                headers: {},
                // optional: header send with url (auth token etc)
                savedDir: _localPath,
                showNotification: true,
                // show download progress in status bar (for Android)
                openFileFromNotification:
                    true, // click on notification to open downloaded file (for Android)
              );
              print("DownloadTaskId:$taskId");
            },
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

  String _localPath = '';

  Future<void> _prepareSaveDir() async {
    _localPath = (await _getSavedDir())!;
    final savedDir = Directory(_localPath);
    if (!savedDir.existsSync()) {
      await savedDir.create();
    }
  }

  Future<String?> _getSavedDir() async {
    String? externalStorageDirPath;
    externalStorageDirPath =
        (await getDownloadsDirectory())?.path??'';

    return externalStorageDirPath;
  }
}
