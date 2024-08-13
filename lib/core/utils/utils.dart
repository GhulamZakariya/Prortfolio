// ignore_for_file: deprecated_member_use

import 'package:url_launcher/url_launcher.dart';

class Utilty {
  static Future<void> openUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  static Future<void> openMail() => openUrl("mailto:khanzakariya22@gmail.com");

  static Future<void> openMyLocation() => openUrl(
      "https://www.google.com/maps/dir/Rehmat+Chowk,+Link+Rehmat+Chowk,+Madina+Colony+Lahore//@31.4897095,74.3222803,13z/data=!4m8!4m7!1m5!1m1!1s0x391905cdc8fc4449:0x1cf0725115e83df6!2m2!1d74.3634798!2d31.4897161!1m0!5m1!1e8?entry=ttu");
  static Future<void> openMyPhoneNo() => openUrl("tel:+92-3042207456");
  static Future<void> openWhatsapp() => openUrl("https://wa.me/03042207456");
}
