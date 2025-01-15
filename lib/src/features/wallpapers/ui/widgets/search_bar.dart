import 'package:flutter/material.dart';
import 'package:wallpaper_hub/src/core/utils/hero_tag.dart';

import '../../../../core/presentation/components/hero_widget.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({
    super.key,
    required this.searchController,
     this.onChanged,
    required this.onSearchPressed,
    required this.onSubmitted,
  });

  final Function(String)? onChanged;
  final Function() onSearchPressed;
  final Function(String query) onSubmitted;
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    return HeroWidget(
      tag: HeroTag.searchField(),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blueGrey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(kToolbarHeight),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 8).copyWith(top: 8),
        padding: const EdgeInsets.only(left: 15),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Search here...",
                ),
                controller: searchController,
                onChanged: onChanged,
                textInputAction: TextInputAction.search,
                onSubmitted: onSubmitted,
              ),
            ),
            IconButton(
                onPressed: onSearchPressed,
                icon: const Icon(Icons.search_rounded))
          ],
        ),
      ),
    );
  }
}
