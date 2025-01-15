import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gap/gap.dart';
import 'package:wallpaper_hub/src/config/di/injection.dart';
import 'package:wallpaper_hub/src/core/presentation/components/cached_photo_widget.dart';
import 'package:wallpaper_hub/src/core/presentation/components/hero_widget.dart';
import 'package:wallpaper_hub/src/core/utils/hero_tag.dart';
import 'package:wallpaper_hub/src/core/utils/sealed/api_state.dart';
import 'package:wallpaper_hub/src/features/wallpapers/ui/bloc/search_photos/search_photos_bloc.dart';
import 'package:wallpaper_hub/src/features/wallpapers/ui/pages/searched_image_preview_page.dart';
import 'package:wallpaper_hub/src/features/wallpapers/ui/widgets/search_bar.dart';

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
      create: (context) => locator<SearchPhotosBloc>()
        ..add(SearchQueryChange(query: widget.query))
        ..add(SearchPhotos()),
      child: Builder(
        builder: (context) {
          var state = context.watch<SearchPhotosBloc>().state;
          return Scaffold(
            appBar: _buildAppBar(context),
            body: Column(
              children: [
                _buildSearchBar(context),
                const Gap(8),
                _buildImageView(context, state),
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
          context.read<SearchPhotosBloc>().add(SearchQueryChange(query: value));
        },
        onSubmitted: (value) {
          if (_searchQueryController.text.trim().isEmpty) {
            return;
          }
          context.read<SearchPhotosBloc>().add(SearchPhotos(refresh: true));
        },
        onSearchPressed: () async {
          FocusManager.instance.primaryFocus?.unfocus();
          if (_searchQueryController.text.isEmpty) return;
          context.read<SearchPhotosBloc>().add(SearchPhotos(refresh: true));
        });
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background);
  }

  Expanded _buildImageView(
    BuildContext context,
    SearchPhotosState state,
  ) {
    return Expanded(
      child: MasonryGridView.count(
        controller: _scrollController
          ..addListener(
            () {
              var maxScroll = _scrollController.position.maxScrollExtent;
              var curatedPhotoBloc = context.read<SearchPhotosBloc>();
              ApiState state = curatedPhotoBloc.state.apiState;
              if (_scrollController.offset == maxScroll &&
                  state is! LoadingState) {
                curatedPhotoBloc.add(SearchPhotos());
              }
            },
          ),
        padding: const EdgeInsets.all(8),
        itemCount: state.photos.length,
        crossAxisCount: 2,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        itemBuilder: (context, index) {
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
      ),
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
              value: BlocProvider.of<SearchPhotosBloc>(context),
              child: SearchedImagePreviewPage(
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
