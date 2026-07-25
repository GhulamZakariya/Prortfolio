import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:my_portfolio/injection/injector.config.dart';

/// Global service locator. Cubits, use cases and services are registered by
/// `@injectable`/`@lazySingleton` annotations and wired in [injector.config.dart].
final GetIt injector = GetIt.instance;

@InjectableInit(
  initializerName: r'$initGetIt',
  preferRelativeImports: true,
  asExtension: false,
)
Future<void> configureDependencies() async => $initGetIt(injector);
