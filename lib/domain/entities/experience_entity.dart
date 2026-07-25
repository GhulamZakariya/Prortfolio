import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:my_portfolio/domain/entities/technology_entity.dart';

part 'experience_entity.freezed.dart';

/// A single professional experience entry (one role at one company).
@freezed
abstract class ExperienceEntity with _$ExperienceEntity {
  const factory ExperienceEntity({
    required String jobTitle,
    required String company,
    required String duration,
    required String description,
    @Default(<String>[]) List<String> responsibilities,
    @Default(<TechnologyEntity>[]) List<TechnologyEntity> technologies,
    @Default(<String>[]) List<String> achievements,
  }) = _ExperienceEntity;
}
