import 'package:flutter/material.dart';

class CustomSliverDelegate extends SliverPersistentHeaderDelegate {
  final double maxHeight;
  final double minHeight;

  final double _maxTitleSize = 30.0;
  final double _minTitleSize = 18.0;

  CustomSliverDelegate({
    required this.maxHeight,
    required this.minHeight,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final percent = shrinkOffset / maxHeight;

    final titleTextSize =
        ((_maxTitleSize * (1 - percent))).clamp(_minTitleSize, _maxTitleSize);

    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Stack(
        children: [
          Opacity(
            opacity: (1 - percent).clamp(0.1, 0.7),
            child: Image.asset(
              "assets/images/keyboard_bg.png",
              colorBlendMode: BlendMode.dstOut,
              height: double.maxFinite,
              width: double.maxFinite,
              fit: BoxFit.cover,
            ),
          ),
          AnimatedPositioned(
            curve: Curves.linear,
            width: MediaQuery.of(context).size.width,
            duration: const Duration(milliseconds: 100),
            bottom: 8.0,
            child: AnimatedContainer(
              duration: const Duration(
                milliseconds: 100,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Wallpaper",
                    softWrap: true,
                    style: TextStyle(
                        fontSize: titleTextSize, color: Colors.black87),
                  ),
                  Text(
                    "Hub",
                    softWrap: true,
                    style: TextStyle(
                      fontSize: titleTextSize,
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(covariant oldDelegate) => true;
}
