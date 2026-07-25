import 'package:flutter/material.dart';
import 'package:my_portfolio/app.dart';
import 'package:my_portfolio/injection/injector.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const App());
}
