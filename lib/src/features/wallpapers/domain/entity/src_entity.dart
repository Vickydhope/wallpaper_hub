import 'package:equatable/equatable.dart';

class SrcEntity extends Equatable {
  final String original;
  final String large;
  final String large2x;
  final String medium;
  final String small;
  final String tiny;
  final String portrait;
  final String landscape;

  const SrcEntity({
    required this.original,
    required this.large,
    required this.large2x,
    required this.medium,
    required this.small,
    required this.tiny,
    required this.portrait,
    required this.landscape,
  });

  @override
  List<Object?> get props =>
      [original, large, large2x, medium, small, tiny, portrait, landscape];
}
