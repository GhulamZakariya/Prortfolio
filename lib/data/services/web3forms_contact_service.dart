import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:my_portfolio/core/constants/environment.dart';
import 'package:my_portfolio/data/errors/app_failure.dart';
import 'package:my_portfolio/domain/entities/contact_message.dart';
import 'package:my_portfolio/domain/services/contact_service.dart';

/// Delivers contact-form submissions to the owner's inbox via
/// [Web3Forms](https://web3forms.com) — no backend, reliable CORS, not on
/// ad-block lists.
///
/// The access key is injected at build time via
/// `--dart-define=web3forms_access_key=...` (never hardcoded). Web3Forms
/// accepts a JSON body and handles the CORS pre-flight, so this works from
/// Flutter web.
@LazySingleton(as: ContactService)
class Web3FormsContactService implements ContactService {
  Web3FormsContactService(this._client);

  final http.Client _client;

  static const String _endpoint = 'https://api.web3forms.com/submit';
  static const String _ownerEmail = 'khanzakariya22@gmail.com';

  @override
  Future<void> send(ContactMessage message) async {
    const accessKey = AppEnvironment.web3formsAccessKey;
    if (accessKey.isEmpty) {
      throw const AppFailure.withMessage(
        'The contact form is not configured yet. Please email me directly at '
        '$_ownerEmail.',
      );
    }

    final http.Response response;
    try {
      response = await _client.post(
        Uri.parse(_endpoint),
        headers: const {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'access_key': accessKey,
          ...message.toFormFields(),
          'from_name': message.name,
          // Honeypot — always empty for real users.
          'botcheck': '',
        }),
      );
    } catch (error) {
      throw AppFailure.from(error);
    }

    final body = _tryDecode(response.body);
    final success = body?['success'] == true;
    if (response.statusCode < 200 ||
        response.statusCode >= 300 ||
        !success) {
      throw AppFailure.withMessage(
        (body?['message'] as String?) ??
            'Message could not be sent (error ${response.statusCode}). '
                'Please email me directly at $_ownerEmail.',
      );
    }
  }

  Map<String, dynamic>? _tryDecode(String source) {
    try {
      final decoded = jsonDecode(source);
      return decoded is Map<String, dynamic> ? decoded : null;
    } catch (_) {
      return null;
    }
  }
}
