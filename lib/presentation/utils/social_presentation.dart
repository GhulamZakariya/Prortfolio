import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_portfolio/domain/entities/social_link.dart';

/// Presentation-only mapping from the pure-domain [SocialKind] to an icon.
IconData socialIcon(SocialKind kind) {
  switch (kind) {
    case SocialKind.email:
      return Icons.mail_outline_rounded;
    case SocialKind.linkedin:
      return FontAwesomeIcons.linkedinIn;
    case SocialKind.instagram:
      return FontAwesomeIcons.instagram;
    case SocialKind.github:
      return FontAwesomeIcons.github;
    case SocialKind.fiverr:
      return FontAwesomeIcons.f;
    case SocialKind.whatsapp:
      return FontAwesomeIcons.whatsapp;
    case SocialKind.phone:
      return Icons.phone_outlined;
    case SocialKind.location:
      return Icons.location_on_outlined;
  }
}

String socialTitle(SocialKind kind) {
  switch (kind) {
    case SocialKind.email:
      return 'Email';
    case SocialKind.linkedin:
      return 'LinkedIn';
    case SocialKind.instagram:
      return 'Instagram';
    case SocialKind.github:
      return 'GitHub';
    case SocialKind.fiverr:
      return 'Fiverr';
    case SocialKind.whatsapp:
      return 'WhatsApp';
    case SocialKind.phone:
      return 'Phone';
    case SocialKind.location:
      return 'Location';
  }
}
