import 'package:injectable/injectable.dart';
import 'package:my_portfolio/core/utils/constants.dart';
import 'package:my_portfolio/core/routes/routes.dart';
import 'package:my_portfolio/domain/entities/education_entity.dart';
import 'package:my_portfolio/domain/entities/experience_entity.dart';
import 'package:my_portfolio/domain/entities/project_entity.dart';
import 'package:my_portfolio/domain/entities/skill_entity.dart';
import 'package:my_portfolio/domain/entities/social_link.dart';
import 'package:my_portfolio/domain/entities/technology_entity.dart';
import 'package:my_portfolio/domain/services/portfolio_repository.dart';

/// Static, in-memory portfolio content. Behind the [PortfolioRepository]
/// interface so it can later be swapped for a CMS/API without UI changes.
@LazySingleton(as: PortfolioRepository)
class StaticPortfolioRepository implements PortfolioRepository {
  // --- Reusable technology chips ---
  static const _flutter =
      TechnologyEntity(name: 'Flutter', logoAsset: AppConstants.flutterImage);
  static const _firebase =
      TechnologyEntity(name: 'Firebase', logoAsset: AppConstants.firebaseImage);
  static const _razorpay = TechnologyEntity(
      name: 'Razorpay', logoAsset: AppConstants.razorPayImage);
  // Payment gateways rendered as text badges (no logo asset bundled).
  static const _stripe = TechnologyEntity(name: 'Stripe');
  static const _xpay = TechnologyEntity(name: 'XPay');

  @override
  List<TechnologyEntity> techStack() => const [_flutter, _firebase, _razorpay];

  @override
  List<ProjectEntity> projects() => const [
        ProjectEntity(
          name: 'Pizza Hut Qatar',
          tagline: 'Food Ordering App',
          description:
              'Built the Pizza Hut Qatar app in Flutter with a smooth, intuitive '
              'ordering flow. Integrated Firebase for auth and real-time updates, '
              'and shipped order tracking, promotions and location-based services '
              'optimized for both iOS and Android.',
          category: ProjectCategory.mobile,
          imageAsset: AppConstants.pizzaHutQatar,
          technologies: [_flutter, _firebase],
          googlePlayUrl:
              'https://play.google.com/store/apps/details?id=com.pizzahut.qatar&hl=en',
          appStoreUrl:
              'https://apps.apple.com/lb/app/pizza-hut-qatar/id1576164932',
        ),
        ProjectEntity(
          name: 'Pizza Hut South Africa',
          tagline: 'Food Ordering App',
          description:
              'Delivered the Pizza Hut South Africa app with Flutter — fast load '
              'times, a responsive UI, Firebase-backed auth and real-time order '
              'updates, plus promotions and store locator features.',
          category: ProjectCategory.mobile,
          imageAsset: AppConstants.pizzaHutSouth,
          technologies: [_flutter, _firebase],
          googlePlayUrl:
              'https://play.google.com/store/apps/details?id=com.pizzahut.rsa&hl=en_ZA',
          appStoreUrl:
              'https://apps.apple.com/us/app/pizza-hut-south-africa/id1455306833',
        ),
        ProjectEntity(
          name: 'KFC Pakistan',
          tagline: 'Ordering App',
          description:
              'KFC Pakistan ordering experience for delivery and pickup — browse '
              'the menu, customize orders and check out, all built with Flutter '
              'and Firebase.',
          category: ProjectCategory.mobile,
          imageAsset: AppConstants.kfcImage,
          technologies: [_flutter, _firebase],
          googlePlayUrl:
              'https://play.google.com/store/apps/details?id=io.bramerz.kfc&hl=en',
          appStoreUrl:
              'https://apps.apple.com/us/app/kfc-pakistan/id1480491422',
        ),
        ProjectEntity(
          name: "Domino's Pizza Pakistan",
          tagline: 'Pizza Delivery App',
          description:
              "Domino's Pakistan delivery app built in Flutter — place live and "
              'future orders, track delivery and enjoy a seamless checkout on '
              'both platforms.',
          category: ProjectCategory.mobile,
          imageAsset: AppConstants.DomImage,
          technologies: [_flutter, _firebase, _xpay],
          googlePlayUrl:
              'https://play.google.com/store/apps/details?id=pk.com.dominos&hl=en',
          appStoreUrl:
              'https://apps.apple.com/pk/app/dominos-pakistan/id1453983132',
        ),
        ProjectEntity(
          name: "Papa John's Pakistan",
          tagline: 'Pizza Ordering App',
          description:
              "Papa John's Pakistan ordering app built in Flutter — browse the "
              'menu, customize pizzas, track orders and check out securely with '
              'integrated Stripe & XPay payments. Firebase powers auth, real-time '
              'updates and push notifications across iOS and Android.',
          category: ProjectCategory.mobile,
          // Official Papa John's app icon, shown as a padded rounded tile.
          iconAsset: AppConstants.papaJohnsImage,
          brandHex: '#2E6B34',
          technologies: [_flutter, _firebase, _stripe, _xpay],
          liveUrl: 'https://www.papajohns.com.pk',
        ),
        ProjectEntity(
          name: 'DSouF Employee App',
          tagline: 'Enterprise / HR',
          description:
              'Employee app for Dubai South staff — submit leave and expense '
              'claims, create memos, generate payslips and apply for documents, '
              'all in one place.',
          category: ProjectCategory.mobile,
          imageAsset: AppConstants.dsuImage,
          technologies: [_flutter, _firebase],
        ),
        ProjectEntity(
          name: 'JSON to Dart Generator',
          tagline: 'Developer Tool',
          description:
              'An in-browser tool that generates strongly-typed Dart model '
              'classes from any JSON object. Built with Flutter and runs right '
              'here on this site.',
          category: ProjectCategory.tools,
          imageAsset: AppConstants.flutterImage,
          technologies: [_flutter],
          liveUrl: Routes.jsonToDart,
          internalRoute: true,
        ),
        ProjectEntity(
          name: 'News Up',
          tagline: 'News Reader',
          description:
              'A news reader app for browsing stories across categories. '
              'Published on the Amazon App Store.',
          category: ProjectCategory.mobile,
          imageAsset: AppConstants.flutterImage,
          technologies: [_flutter],
        ),
        ProjectEntity(
          name: 'Music Lab',
          tagline: 'Music Player',
          description:
              'A simple, clean music player app. Published on the Amazon App '
              'Store.',
          category: ProjectCategory.mobile,
          imageAsset: AppConstants.flutterImage,
          technologies: [_flutter],
        ),
      ];

  @override
  List<SkillEntity> skills() => const [
        // Languages
        SkillEntity(
            name: 'Dart', level: 0.95, category: SkillCategory.languages),
        SkillEntity(
            name: 'JavaScript', level: 0.7, category: SkillCategory.languages),
        SkillEntity(
            name: 'Python', level: 0.65, category: SkillCategory.languages),
        SkillEntity(name: 'PHP', level: 0.6, category: SkillCategory.languages),
        SkillEntity(
            name: 'Swift', level: 0.55, category: SkillCategory.languages),
        // Frameworks & SDKs
        SkillEntity(
            name: 'Flutter', level: 0.95, category: SkillCategory.frameworks),
        SkillEntity(
            name: 'Firebase', level: 0.9, category: SkillCategory.frameworks),
        SkillEntity(
            name: 'REST APIs', level: 0.85, category: SkillCategory.frameworks),
        SkillEntity(
            name: 'BLoC / Clean Arch',
            level: 0.85,
            category: SkillCategory.frameworks),
        // Payments
        SkillEntity(
            name: 'Stripe', level: 0.85, category: SkillCategory.payments),
        SkillEntity(
            name: 'XPay', level: 0.8, category: SkillCategory.payments),
        SkillEntity(
            name: 'Razorpay', level: 0.8, category: SkillCategory.payments),
        SkillEntity(
            name: 'In-App Purchases',
            level: 0.75,
            category: SkillCategory.payments),
        // Tools & Platforms
        SkillEntity(name: 'Git', level: 0.9, category: SkillCategory.tools),
        SkillEntity(
            name: 'Play Store / App Store',
            level: 0.9,
            category: SkillCategory.tools),
        SkillEntity(
            name: 'CI/CD', level: 0.7, category: SkillCategory.tools),
      ];

  @override
  List<ExperienceEntity> experiences() => const [
        ExperienceEntity(
          jobTitle: 'Flutter Developer',
          company: 'Simplex Technologies',
          duration: '2021 — Present',
          description:
              'Design and ship production-grade Flutter apps end to end for '
              'global food & enterprise brands — from architecture to store '
              'release on iOS and Android.',
          responsibilities: [
            'Architect features with Clean Architecture + BLoC/Cubit and '
                'reusable, testable components',
            'Integrate Firebase auth, real-time data and push notifications',
            'Integrate secure payments via Stripe, XPay and Razorpay',
            'Collaborate in cross-functional teams; own release & maintenance '
                'on the App Store and Play Store',
          ],
          technologies: [_flutter, _firebase, _stripe, _xpay],
          achievements: [
            "Shipped Pizza Hut (Qatar & South Africa), KFC, Domino's and Papa "
                "John's Pakistan to millions of users",
            'Built HR/enterprise apps (leave, expense, payslips) for Dubai South',
            'Established a reusable Clean-Architecture foundation adopted across '
                'multiple production apps',
          ],
        ),
      ];

  @override
  List<EducationEntity> education() => const [
        EducationEntity(
          degree: 'B.S. in Software Engineering',
          university: 'COMSATS University Islamabad — Sahiwal Campus',
          year: 'Graduated 2021',
          coursework: [
            'Data Structures & Algorithms',
            'Object-Oriented Programming',
            'Database Systems',
            'Software Engineering',
            'Mobile Application Development',
            'Web Technologies',
          ],
        ),
      ];

  @override
  List<SocialLink> socials() => const [
        SocialLink(
          kind: SocialKind.email,
          label: 'Khanzakariya22@gmail.com',
          url: 'mailto:khanzakariya22@gmail.com',
        ),
        SocialLink(
          kind: SocialKind.linkedin,
          label: 'LinkedIn',
          url: AppConstants.linkedInUrl,
        ),
        SocialLink(
          kind: SocialKind.github,
          label: 'GitHub',
          url: AppConstants.githubUrl,
        ),
        SocialLink(
          kind: SocialKind.instagram,
          label: 'Instagram',
          url: AppConstants.instagramUrl,
        ),
        SocialLink(
          kind: SocialKind.fiverr,
          label: 'Fiverr',
          url: AppConstants.fiverrUrl,
        ),
        SocialLink(
          kind: SocialKind.whatsapp,
          label: '+92 304 2207456',
          url: 'https://wa.me/923042207456',
        ),
        SocialLink(
          kind: SocialKind.phone,
          label: '+92 304 2207456',
          url: 'tel:+923042207456',
        ),
        SocialLink(
          kind: SocialKind.location,
          label: 'Lahore, Pakistan',
          url:
              'https://www.google.com/maps/place/Lahore,+Pakistan',
        ),
      ];
}
