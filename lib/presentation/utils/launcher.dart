import 'package:url_launcher/url_launcher.dart';

/// Opens external URLs / mailto / tel links using the current url_launcher API.
class Launcher {
  const Launcher._();

  static Future<void> open(String url) async {
    if (url.isEmpty) return;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.platformDefault);
    }
  }
}
