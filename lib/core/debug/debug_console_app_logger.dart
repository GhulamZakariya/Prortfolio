import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Lightweight logging mixin used by Cubits/services.
///
/// Mirrors the team reference app: implementers expose a [context] tag and call
/// [t]/[d]/[e]; nothing is logged in release builds.
mixin DebugConsoleAppLogger {
  static final Logger _logger = Logger(printer: PrettyPrinter(methodCount: 0));

  /// Short tag identifying the source (e.g. `'ContactCubit'`).
  String get context;

  void t(dynamic message) {
    if (!kDebugMode) return;
    _logger.t('[$context] $message');
  }

  void d(dynamic message) {
    if (!kDebugMode) return;
    _logger.d('[$context] $message');
  }

  void e(dynamic message, {Object? error, StackTrace? stackTrace}) {
    if (!kDebugMode) return;
    _logger.e('[$context] $message', error: error, stackTrace: stackTrace);
  }
}
