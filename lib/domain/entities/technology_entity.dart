import 'package:freezed_annotation/freezed_annotation.dart';

part 'technology_entity.freezed.dart';

/// A technology/tool used on a project or listed as a skill.
@freezed
abstract class TechnologyEntity with _$TechnologyEntity {
  const factory TechnologyEntity({
    required String name,
    String? logoAsset,
  }) = _TechnologyEntity;
}
