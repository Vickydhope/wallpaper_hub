import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gap/gap.dart';
import 'package:wallpaper_hub/src/config/di/injection.dart';
import 'package:wallpaper_hub/src/core/presentation/components/cached_photo_widget.dart';
import 'package:wallpaper_hub/src/core/utils/extensions/animation_helper.dart';
import 'package:wallpaper_hub/src/core/utils/sealed/api_state.dart';
import 'package:wallpaper_hub/src/features/wallpapers/ui/bloc/curated_photos/curated_photos_bloc.dart';
import 'package:wallpaper_hub/src/features/wallpapers/ui/pages/image_preview_page.dart';

import 'package:wallpaper_hub/src/features/wallpapers/ui/widgets/search_bar.dart';

import '../../../../core/presentation/shimmer/dashboard_shimmer.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key, required this.query});

  final String query;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late ScrollController _scrollController;
  late final TextEditingController _searchQueryController;

  @override
  void initState() {
    _scrollController = ScrollController();
    _searchQueryController = TextEditingController(text: widget.query);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => locator<CuratedPhotosBloc>()
        ..add(SearchQueryChange(query: widget.query))
        ..add(SearchPhotosEvent()),
      child: Builder(
        builder: (context) {
          var state = context.watch<CuratedPhotosBloc>().state;
          return Scaffold(
            appBar: _buildAppBar(context),
            body: Column(
              children: [
                _buildSearchBar(context),
                const Gap(8),
                Expanded(child: _buildImageView(context, state)),
              ],
            ),
          );
        },
      ),
    );
  }

  SearchBarWidget _buildSearchBar(BuildContext context) {
    return SearchBarWidget(
        searchController: _searchQueryController,
        onChanged: (value) {
          context
              .read<CuratedPhotosBloc>()
              .add(SearchQueryChange(query: value));
        },
        onSubmitted: (value) {
          if (_searchQueryController.text.trim().isEmpty) {
            return;
          }
          context
              .read<CuratedPhotosBloc>()
              .add(SearchPhotosEvent(refresh: true));
        },
        onSearchPressed: () async {
          FocusManager.instance.primaryFocus?.unfocus();
          if (_searchQueryController.text.isEmpty) return;
          context
              .read<CuratedPhotosBloc>()
              .add(SearchPhotosEvent(refresh: true));
        });
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
        title: const Text("Search"),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background);
  }

  Widget _buildImageView(
    BuildContext context,
    CuratedPhotosState state,
  ) {
    var border = BorderRadius.circular(10);

    return MasonryGridView.count(
      controller: _scrollController
        ..addListener(
          () {
            var maxScroll = _scrollController.position.maxScrollExtent;
            var curatedPhotoBloc = context.read<CuratedPhotosBloc>();
            ApiState state = curatedPhotoBloc.state.apiState;
            if (_scrollController.offset == maxScroll &&
                state is! LoadingState) {
              curatedPhotoBloc.add(SearchPhotosEvent());
            }
          },
        ),
      padding: const EdgeInsets.all(8),
      itemCount: state.photos.length + 1,
      crossAxisCount: 2,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      itemBuilder: (context, index) {
        if (index == state.photos.length) {
          return AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: border,
                color: Colors.grey.shade400,
              ),
            ).shimmer(),
          );
        }
        var photoSrc = state.photos[index].src;

        return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              onTap: () {
                _navigateToPreviewPage(context, index);
              },
              child: CachedPhotoWidget(
                original: photoSrc.medium,
                small: photoSrc.small,
              ),
            ));
      },
    );
  }

  void _navigateToPreviewPage(BuildContext context, int index) {
    Navigator.of(context).push(
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
        },
      ),
    );
  }
}
