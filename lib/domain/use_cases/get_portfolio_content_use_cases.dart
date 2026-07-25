import 'package:injectable/injectable.dart';
import 'package:my_portfolio/domain/entities/education_entity.dart';
import 'package:my_portfolio/domain/entities/experience_entity.dart';
import 'package:my_portfolio/domain/entities/project_entity.dart';
import 'package:my_portfolio/domain/entities/skill_entity.dart';
import 'package:my_portfolio/domain/entities/social_link.dart';
import 'package:my_portfolio/domain/entities/technology_entity.dart';
import 'package:my_portfolio/domain/services/portfolio_repository.dart';

/// Content read use cases. Each is a single, named business action backed by
/// the [PortfolioRepository] (currently static data).

@injectable
class GetProjectsUseCase {
  GetProjectsUseCase(this._repository);
  final PortfolioRepository _repository;
  List<ProjectEntity> run() => _repository.projects();
}

@injectable
class GetSkillsUseCase {
  GetSkillsUseCase(this._repository);
  final PortfolioRepository _repository;
  List<SkillEntity> run() => _repository.skills();
}

@injectable
class GetExperiencesUseCase {
  GetExperiencesUseCase(this._repository);
  final PortfolioRepository _repository;
  List<ExperienceEntity> run() => _repository.experiences();
}

@injectable
class GetEducationUseCase {
  GetEducationUseCase(this._repository);
  final PortfolioRepository _repository;
  List<EducationEntity> run() => _repository.education();
}

@injectable
class GetSocialLinksUseCase {
  GetSocialLinksUseCase(this._repository);
  final PortfolioRepository _repository;
  List<SocialLink> run() => _repository.socials();
}

@injectable
class GetTechStackUseCase {
  GetTechStackUseCase(this._repository);
  final PortfolioRepository _repository;
  List<TechnologyEntity> run() => _repository.techStack();
}
