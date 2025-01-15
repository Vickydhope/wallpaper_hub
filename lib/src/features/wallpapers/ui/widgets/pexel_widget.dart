import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class PexelWidget extends StatelessWidget {
  const PexelWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Made using",
          style: TextStyle(fontSize: 10),
        ),
        const Gap(8),
        Image.asset(
          "assets/images/pexels_logo.png",
          height: 24,
        ),
      ],
    );
  }
}
