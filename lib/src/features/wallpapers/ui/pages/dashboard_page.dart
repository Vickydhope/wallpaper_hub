import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gap/gap.dart';
import 'package:wallpaper_hub/src/config/di/injection.dart';
import 'package:wallpaper_hub/src/core/presentation/components/cached_photo_widget.dart';
import 'package:wallpaper_hub/src/core/presentation/shimmer/dashboard_shimmer.dart';
import 'package:wallpaper_hub/src/core/utils/delegates/custom_sliver_delegate.dart';
import 'package:wallpaper_hub/src/core/utils/extensions/animation_helper.dart';
import 'package:wallpaper_hub/src/core/utils/sealed/api_state.dart';
import 'package:wallpaper_hub/src/features/wallpapers/data/model/category_model.dart';
import 'package:wallpaper_hub/src/features/wallpapers/ui/bloc/curated_photos/curated_photos_bloc.dart';
import 'package:wallpaper_hub/src/features/wallpapers/ui/pages/image_preview_page.dart';
import 'package:wallpaper_hub/src/features/wallpapers/ui/pages/search_page.dart';
import 'package:wallpaper_hub/src/features/wallpapers/ui/widgets/pexel_widget.dart';
import 'package:wallpaper_hub/src/features/wallpapers/ui/widgets/search_bar.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> with TickerProviderStateMixin {
  final double gapH = 16;
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    _searchQueryController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchQueryController.dispose();
    super.dispose();
  }

  late final TextEditingController _searchQueryController;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (context) {
        return locator<CuratedPhotosBloc>()..add(GetCuratedPhotosEvent());
      },
      child: Builder(builder: (context) {
        return Scaffold(
          body: RefreshIndicator(
            onRefresh: () async {
              _getCuratedPhotos(context, refresh: true);
            },
            child: CustomScrollView(
              physics: const ClampingScrollPhysics(),
              controller: _scrollController
                ..addListener(
                  () {
                    var maxScroll = _scrollController.offset == _scrollController.position.maxScrollExtent;
                    var curatedPhotoBloc = context.read<CuratedPhotosBloc>();
                    ApiState state = curatedPhotoBloc.state.apiState;
                    if (maxScroll && state is! LoadingState) {
                      _getCuratedPhotos(context);
                    }
                  },
                ),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              slivers: [
                _buildDashboardHeader(),
                const SliverToBoxAdapter(child: Gap(8)),
                const SliverToBoxAdapter(
                  child: PexelWidget(),
                ),
                _buildSearchBar(context),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 60,
                    child: buildCategoriesList(context),
                  ),
                ),
                const SliverToBoxAdapter(child: Gap(8)),
                _buildFeaturedPhotoText(),
                buildCuratedPhotosList(),
              ],
            ),
          ),
        );
      }),
    );
  }

  SliverPersistentHeader _buildDashboardHeader() {
    return SliverPersistentHeader(
      pinned: true,
      floating: true,
      delegate: CustomSliverDelegate(
        maxHeight: 180,
        minHeight: 80,
      ),
    );
  }

  SliverToBoxAdapter _buildSearchBar(BuildContext context) {
    return SliverToBoxAdapter(
      child: SearchBarWidget(
        searchController: _searchQueryController,
        onSearchPressed: () async {
          FocusManager.instance.primaryFocus?.unfocus();
          if (_searchQueryController.text.trim().isEmpty) {
            return;
          }
          await _navigateToSearch(context, _searchQueryController.text);
        },
        onSubmitted: (value) {
          if (_searchQueryController.text.trim().isEmpty) {
            return;
          }
          _navigateToSearch(
            context,
            _searchQueryController.text,
          );
        },
      ),
    );
  }

  SliverPadding _buildFeaturedPhotoText() {
    return const SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      sliver: SliverToBoxAdapter(
        child: Text(
          "Featured Photos",
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.black87),
        ),
      ),
    );
  }

  Future<void> _navigateToSearch(BuildContext context, String query) async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => SearchPage(
        query: query,
      ),
    ));
  }

  Widget buildCuratedPhotosList() {
    var border = BorderRadius.circular(10);
    return BlocConsumer<CuratedPhotosBloc, CuratedPhotosState>(
      builder: (context, state) {
        if (state.photos.isEmpty && state.apiState is LoadingState) {
          return SliverToBoxAdapter(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: const DashboardShimmer(),
            ),
          );
        }

        ///List of photos
        return SliverPadding(
          padding: const EdgeInsets.all(8),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              childCount: state.photos.length + 1,
              (context, index) {
                if (index == state.photos.length) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: border,
                      color: Colors.grey.shade400,
                    ),
                  ).shimmer();
                }

                final picture = state.photos[index];
                return GestureDetector(
                  onTap: () {
                    _navigateToImagePreview(context, index: index);
                  },
                  child: ClipRRect(
                    borderRadius: border,
                    child: CachedPhotoWidget(
                      original: picture.src.medium,
                      placeholder: Container(
                        color: Colors.grey.shade400,
                      ).shimmer(),
                    ),
                  ),
                );
              },
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
        );
      },
      listener: (BuildContext context, CuratedPhotosState state) {
        switch (state.apiState) {
          case InitialState():
          case LoadingState():
          case ErrorState(message: var message):
          case SuccessState():
        }
      },
    );
  }

  ListView buildCategoriesList(BuildContext context) {
    final categories = CategoryModel.categories()..shuffle(Random(1));
    return ListView.builder(
      itemCount: categories.length,
      padding: const EdgeInsets.only(top: 8, left: 8),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) => CategoryTile(
        onTap: () {
          var category = categories[index];
          _navigateToSearch(context, category.title);
        },
        category: categories[index],
      ),
    );
  }

  Future<void> _navigateToImagePreview(
    BuildContext context, {
    required int index,
  }) async {
    await Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: 200.ms,
        pageBuilder: (_, animation, secondaryAnimation) {
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutExpo,
          );

          return SlideTransition(
            position: Tween<Offset>(
              end: Offset.zero,
              begin: Offset(
                curvedAnimation.value,
                0,
              ),
            ).animate(curvedAnimation),
            child: BlocProvider.value(
              value: BlocProvider.of<CuratedPhotosBloc>(context),
              child: ImagePreviewPage(
                index: index,
                animation: curvedAnimation,
              ),
            ),
          );

          return FadeTransition(
            opacity: curvedAnimation,
            child: ImagePreviewPage(
              index: index,
              animation: curvedAnimation,
            ),
          );
        },
      ),
    );
  }

  void _getCuratedPhotos(BuildContext context, {bool refresh = false}) {
    var curatedPhotoBloc = context.read<CuratedPhotosBloc>();
    curatedPhotoBloc.add(GetCuratedPhotosEvent(refresh: refresh));
  }
}

class CategoryTile extends StatelessWidget {
  const CategoryTile({
    required this.category,
    required this.onTap,
    super.key,
  });

  final Function() onTap;

  final double borderRadius = 8;
  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: CachedPhotoWidget(
                original: category.image,
                width: 100,
                height: 50,
              ),
            ),
            ClipRRect(
                borderRadius: BorderRadius.circular(borderRadius),
                child: Container(
                  color: Colors.black.withOpacity(0.4),
                  height: 50,
                  width: 100,
                )),
            Align(
              alignment: Alignment.center,
              child: Text(
                category.title,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              ),
            )
          ],
        ),
      ),
    );
  }
}
