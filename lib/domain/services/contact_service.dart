import 'package:my_portfolio/domain/entities/contact_message.dart';

/// Delivers a contact-form submission to the site owner's inbox.
/// Implemented in the data layer (currently via FormSubmit — no backend).
abstract class ContactService {
  Future<void> send(ContactMessage message);
}
