import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:my_portfolio/domain/entities/technology_entity.dart';

part 'project_entity.freezed.dart';

/// Category used by the projects filter chips.
enum ProjectCategory {
  mobile('Mobile Apps'),
  flutter('Flutter'),
  tools('Tools');

  const ProjectCategory(this.label);
  final String label;
}

/// A portfolio project/case-study.
@freezed
abstract class ProjectEntity with _$ProjectEntity {
  const ProjectEntity._();

  const factory ProjectEntity({
    required String name,
    required String tagline,
    required String description,
    required ProjectCategory category,
    String? imageAsset,
    // App icon/logo shown as a padded, rounded tile on a brand-colored cover
    // (used when there's no full screenshot). Takes priority over [imageAsset].
    String? iconAsset,
    // Brand accent (e.g. '#2E6B34') for the icon-cover background; falls back
    // to the theme accent.
    String? brandHex,
    @Default(<TechnologyEntity>[]) List<TechnologyEntity> technologies,
    @Default('') String liveUrl,
    @Default('') String githubUrl,
    @Default('') String googlePlayUrl,
    @Default('') String appStoreUrl,
    @Default(false) bool internalRoute,
  }) = _ProjectEntity;

  bool get hasLiveLinks =>
      liveUrl.isNotEmpty ||
      googlePlayUrl.isNotEmpty ||
      appStoreUrl.isNotEmpty;
}
