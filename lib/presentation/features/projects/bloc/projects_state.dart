import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:my_portfolio/domain/entities/project_entity.dart';

part 'projects_state.freezed.dart';

@freezed
abstract class ProjectsState with _$ProjectsState {
  const ProjectsState._();

  const factory ProjectsState({
    @Default(<ProjectEntity>[]) List<ProjectEntity> all,
    ProjectCategory? filter,
  }) = _ProjectsState;

  /// `null` filter means "All".
  List<ProjectEntity> get visible => filter == null
      ? all
      : all.where((project) => project.category == filter).toList();
}
