import 'package:my_portfolio/core/routes/routes.dart';
import 'package:my_portfolio/core/utils/constants.dart';
import 'package:my_portfolio/models/link.dart';
import 'package:my_portfolio/models/technology.dart';

class ProjectModel {
  final String project;
  final String title;
  final String description;
  final String? appPhotos;
  final String projectLink;
  final bool internalLink;
  final List<TechnologyModel> techUsed;
  List<LinkModel>? links = [];
  final String? buttonText;

  ProjectModel({
    required this.project,
    required this.title,
    required this.description,
    this.appPhotos,
    required this.projectLink,
    this.internalLink = false,
    required this.techUsed,
    this.buttonText,
    this.links,
  });

  static List<ProjectModel> projects = [
    ProjectModel(
      project: "Pizza Hut Qatar",
      title: "Pizza OrderApp",
      description:
          "Developed the Pizza Hut Qatar app using Flutter, delivering a smooth and intuitive ordering experience. Integrated Firebase for authentication and real-time updates. Optimized performance for iOS and Android, ensuring fast loading times and a responsive UI. Implemented features like order tracking, promotions, and location-based services.",
      appPhotos: AppConstants.pizzaHutQatar,
      projectLink: "https://apps.apple.com/lb/app/pizza-hut-qatar/id1576164932",
      techUsed: [
        TechnologyConstants.flutter,
        TechnologyConstants.firebase,
      ],
    ),
    ProjectModel(
      project: "Pizza Hut South Africa",
      title: "Pizza OrderApp",
      description:
          "Developed the Pizza Hut Qatar app using Flutter, delivering a smooth and intuitive ordering experience. Integrated Firebase for authentication and real-time updates. Optimized performance for iOS and Android, ensuring fast loading times and a responsive UI. Implemented features like order tracking, promotions, and location-based services.",
      appPhotos: AppConstants.pizzaHutSouth,
      projectLink:
          "https://apps.apple.com/us/app/pizza-hut-south-africa/id1455306833",
      techUsed: [
        TechnologyConstants.flutter,
        TechnologyConstants.firebase,
      ],
    ),
    ProjectModel(
      project: "DSouF",
      title: "Employee App",
      description:
          "Its employee app for Dubai South Employees where they can do everything like submit leave , expense claim, create memo, generate payslips and apply for documnets and many more",
      appPhotos: AppConstants.dsuImage,
      projectLink: "",
      techUsed: [
        TechnologyConstants.flutter,
        TechnologyConstants.firebase,
      ],
    ),
    ProjectModel(
      project: "KFC Pakistan",
      title: "Ordering App",
      description:
          "Burger app where you can order burgers  chicken at home also pick and enjoy",
      appPhotos: AppConstants.kfcImage,
      projectLink: "https://apps.apple.com/us/app/kfc-pakistan/id1480491422",
      techUsed: [
        TechnologyConstants.flutter,
        TechnologyConstants.firebase,
      ],
    ),
    ProjectModel(
      project: "Domino’s Pizza Pakistan",
      title: "Pizza Delivery App",
      description:
          "Implementation the functioning of pizza app where you can order your pizza through this app . You can also do future order in this app . And get your pizza at home",
      appPhotos: AppConstants.DomImage,
      projectLink:
          "https://apps.apple.com/pk/app/dominos-pakistan/id1453983132",
      techUsed: [
        TechnologyConstants.flutter,
        TechnologyConstants.firebase,
      ],
      buttonText: "",
    ),
    ProjectModel(
      project: "Flutter",
      title: "Json to Dart Generator",
      description: "Generate Dart class using Json Object using Flutter",
      appPhotos: AppConstants.flutterImage,
      internalLink: true,
      projectLink: Routes.jsonToDart,
      techUsed: [
        TechnologyConstants.flutter,
      ],
      buttonText: "",
    ),
    ProjectModel(
      project: "Flutter App",
      title: "News Up App",
      description:
          "This application is used basically for viewing different news. Launched the app in Amazon AppStore",
      appPhotos: AppConstants.flutterImage,
      projectLink: "",
      techUsed: [
        TechnologyConstants.flutter,
      ],
    ),
    ProjectModel(
      project: "Flutter App",
      title: "Music Lab",
      description:
          "A Simple Music Player App. Launched the app in Amazon AppStore",
      appPhotos: AppConstants.flutterImage,
      projectLink: "",
      techUsed: [
        TechnologyConstants.flutter,
      ],
    ),
  ];

  static List<ProjectModel> demos = [
    ProjectModel(
      project: "Flutter App",
      title: "Flutter Web Portfolio",
      description: "",
      appPhotos: AppConstants.portfolioGif,
      projectLink: "",
      techUsed: [],
      buttonText: "",
    ),
  ];
}
