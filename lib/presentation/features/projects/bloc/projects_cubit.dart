import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:my_portfolio/domain/entities/project_entity.dart';
import 'package:my_portfolio/domain/use_cases/get_portfolio_content_use_cases.dart';
import 'package:my_portfolio/presentation/features/projects/bloc/projects_state.dart';

/// Loads projects and owns the active category filter.
@injectable
class ProjectsCubit extends Cubit<ProjectsState> {
  ProjectsCubit(this._getProjectsUseCase) : super(const ProjectsState());

  final GetProjectsUseCase _getProjectsUseCase;

  void load() => emit(state.copyWith(all: _getProjectsUseCase.run()));

  /// `null` selects "All". Rebuilt via the constructor because freezed's
  /// `copyWith` can't set a nullable field back to null.
  void setFilter(ProjectCategory? category) =>
      emit(ProjectsState(all: state.all, filter: category));
}
