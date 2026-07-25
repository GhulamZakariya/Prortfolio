import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

/// Third-party singletons that can't be annotated directly.
@module
abstract class AppModule {
  @lazySingleton
  http.Client get httpClient => http.Client();
}
