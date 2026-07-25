import 'package:injectable/injectable.dart';
import 'package:my_portfolio/domain/entities/contact_message.dart';
import 'package:my_portfolio/domain/services/contact_service.dart';

/// Sends a contact-form submission to the site owner.
@injectable
class SendContactMessageUseCase {
  SendContactMessageUseCase(this._service);

  final ContactService _service;

  Future<void> run(ContactMessage message) => _service.send(message);
}
