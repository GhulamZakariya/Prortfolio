import 'package:my_portfolio/domain/entities/education_entity.dart';
import 'package:my_portfolio/domain/entities/experience_entity.dart';
import 'package:my_portfolio/domain/entities/project_entity.dart';
import 'package:my_portfolio/domain/entities/skill_entity.dart';
import 'package:my_portfolio/domain/entities/social_link.dart';
import 'package:my_portfolio/domain/entities/technology_entity.dart';

/// Source of the portfolio's content. Implemented in the data layer (currently
/// static Dart, but the interface lets it swap to a CMS/API later without
/// touching presentation).
abstract class PortfolioRepository {
  List<ProjectEntity> projects();
  List<SkillEntity> skills();
  List<ExperienceEntity> experiences();
  List<EducationEntity> education();
  List<SocialLink> socials();
  List<TechnologyEntity> techStack();
}
