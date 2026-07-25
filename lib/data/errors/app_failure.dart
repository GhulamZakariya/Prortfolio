import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_failure.freezed.dart';

/// A lean, self-contained failure type.
///
/// The reference app's `ResponseError` is coupled to Dio/HTTP status codes;
/// this static site has no backend beyond the contact-form POST, so we model
/// only the failures that can actually occur here — keeping the same
/// `AppFailure.from(e)` ergonomics without pulling in networking infra.
@freezed
sealed class AppFailure with _$AppFailure implements Exception {
  const AppFailure._();

  const factory AppFailure.network() = _Network;
  const factory AppFailure.server() = _Server;
  const factory AppFailure.withMessage(String message) = _WithMessage;
  const factory AppFailure.unexpected() = _Unexpected;

  /// Normalizes any thrown object into an [AppFailure].
  factory AppFailure.from(Object error) {
    if (error is AppFailure) return error;
    final text = error.toString().toLowerCase();
    if (text.contains('socket') ||
        text.contains('connection') ||
        text.contains('network') ||
        text.contains('failed host lookup') ||
        text.contains('failed to fetch') ||
        text.contains('xmlhttprequest') ||
        text.contains('clientexception')) {
      return const AppFailure.network();
    }
    return const AppFailure.unexpected();
  }

  /// A user-facing message safe to render in the UI.
  String get message => switch (this) {
        _Network() =>
          'No internet connection. Please check your network and try again.',
        _Server() => 'Something went wrong on the server. Please try again.',
        _WithMessage(:final message) => message,
        _Unexpected() => 'Something went wrong. Please try again.',
      };
}
