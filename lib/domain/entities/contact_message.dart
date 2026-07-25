import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_message.freezed.dart';

/// A message submitted through the contact form.
@freezed
abstract class ContactMessage with _$ContactMessage {
  const ContactMessage._();

  const factory ContactMessage({
    required String name,
    required String email,
    required String subject,
    required String message,
  }) = _ContactMessage;

  /// Form fields sent to the mail delivery service.
  Map<String, String> toFormFields() => {
        'name': name,
        'email': email,
        'subject': subject,
        'message': message,
      };
}
