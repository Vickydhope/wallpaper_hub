import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gap/gap.dart';
import 'package:wallpaper_hub/src/core/utils/extensions/animation_helper.dart';

class DashboardShimmer extends StatelessWidget {
  const DashboardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        /*Container(
          decoration: const BoxDecoration(color: Colors.grey.withOpacity(0.8),
          width: MediaQuery.of(context).size.width,
          height: 200,
        ),
        const Gap(8),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16), color: Colors.grey.withOpacity(0.8),
          width: MediaQuery.of(context).size.width,
          height: 45,
        ),
        const Gap(8),*/
        /*SizedBox(
          height: 40,
          child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.only(left: 8, right: 8),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => Container(
                    width: 100,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.grey.shade400,
                    ),
                  ),
              separatorBuilder: (context, index) => Gap(8),
              itemCount: 4),
        ),*/
/*        const Gap(8),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.grey.shade400,
            ),
            margin: const EdgeInsets.only(left: 8),
            width: 200,
            padding: EdgeInsets.all(16),
          ),
        ),*/
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomScrollView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              slivers: [
                SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return GestureDetector(
                        onTap: () {},
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    },
                    childCount: 10,
                  ),
                  gridDelegate: SliverQuiltedGridDelegate(
                    crossAxisCount: 3,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    repeatPattern: QuiltedGridRepeatPattern.inverted,
                    pattern: const [
                      QuiltedGridTile(1, 1),
                      QuiltedGridTile(2, 2),
                      QuiltedGridTile(2, 1),
                      QuiltedGridTile(1, 1),
                      QuiltedGridTile(1, 1),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    ).shimmer();
  }
}
