import 'package:freezed_annotation/freezed_annotation.dart';

part 'education_entity.freezed.dart';

/// A single education entry (degree at an institution).
@freezed
abstract class EducationEntity with _$EducationEntity {
  const factory EducationEntity({
    required String degree,
    required String university,
    required String year,
    @Default(<String>[]) List<String> coursework,
  }) = _EducationEntity;
}
