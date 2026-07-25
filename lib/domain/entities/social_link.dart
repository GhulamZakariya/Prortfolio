import 'package:freezed_annotation/freezed_annotation.dart';

part 'social_link.freezed.dart';

/// Kinds of social/contact links. Presentation maps each to an icon.
enum SocialKind { email, linkedin, instagram, github, fiverr, whatsapp, phone, location }

@freezed
abstract class SocialLink with _$SocialLink {
  const factory SocialLink({
    required SocialKind kind,
    required String label,
    required String url,
  }) = _SocialLink;
}
