import 'package:amplitude_flutter/amplitude.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:my_portfolio/core/constants/environment.dart';
import 'package:my_portfolio/core/debug/debug_console_app_logger.dart';

/// Thin wrapper around Amplitude analytics. Registered via DI and used by the
/// presentation layer instead of the old Riverpod provider.
@lazySingleton
class AnalyticsService with DebugConsoleAppLogger {
  Amplitude? _analytics;
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  @override
  String get context => 'AnalyticsService';

  @PostConstruct()
  void init() {
    _analytics = Amplitude.getInstance(instanceName: 'ghulam-zakariya');
    _analytics?.init(AppEnvironment.amplitudeAPIKey);
  }

  Future<void> logStartupEvent() async {
    final info = <String, String>{};
    if (kIsWeb) {
      final web = await _deviceInfo.webBrowserInfo;
      info.addAll({
        'browser': web.browserName.name,
        'platform': web.platform.toString(),
        'userAgent': web.userAgent.toString(),
        'language': web.language.toString(),
      });
    }
    d('startup: $info');
    _analytics?.logEvent('startup', eventProperties: info);
  }

  Future<void> logScreen(String screenName) async {
    d('screen: $screenName');
    _analytics?.logEvent('screens_log', eventProperties: {
      'screenName': screenName,
    });
  }
}
