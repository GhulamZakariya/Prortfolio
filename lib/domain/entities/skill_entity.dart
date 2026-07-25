import 'package:freezed_annotation/freezed_annotation.dart';

part 'skill_entity.freezed.dart';

enum SkillCategory {
  languages('Languages'),
  frameworks('Frameworks & SDKs'),
  payments('Payments'),
  tools('Tools & Platforms');

  const SkillCategory(this.label);
  final String label;
}

/// A skill with a proficiency level (0.0 – 1.0) for the animated progress bars.
@freezed
abstract class SkillEntity with _$SkillEntity {
  const factory SkillEntity({
    required String name,
    required double level,
    required SkillCategory category,
  }) = _SkillEntity;
}
