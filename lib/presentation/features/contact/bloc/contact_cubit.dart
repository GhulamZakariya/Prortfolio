import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:my_portfolio/core/debug/debug_console_app_logger.dart';
import 'package:my_portfolio/data/errors/app_failure.dart';
import 'package:my_portfolio/domain/entities/contact_message.dart';
import 'package:my_portfolio/domain/use_cases/send_contact_message_use_case.dart';
import 'package:my_portfolio/presentation/common/base_status.dart';
import 'package:my_portfolio/presentation/features/contact/bloc/contact_state.dart';

/// Handles contact-form submission state (loading / success / failure).
/// Field values live in the form's controllers; the cubit owns only the async
/// delivery status.
@injectable
class ContactCubit extends Cubit<ContactState> with DebugConsoleAppLogger {
  ContactCubit(this._sendContactMessageUseCase) : super(const ContactState());

  final SendContactMessageUseCase _sendContactMessageUseCase;

  @override
  String get context => 'ContactCubit';

  Future<void> submit(ContactMessage message) async {
    if (state.submitStatus.isLoading) return;
    emit(state.copyWith(submitStatus: const BaseStatus.loading()));
    try {
      await _sendContactMessageUseCase.run(message);
      emit(state.copyWith(submitStatus: const BaseStatus.success()));
    } catch (error, stackTrace) {
      e('Contact submit failed', error: error, stackTrace: stackTrace);
      emit(state.copyWith(
        submitStatus: BaseStatus.failure(AppFailure.from(error)),
      ));
    }
  }

  /// Returns the form to its idle state (e.g. after showing a success message).
  void reset() => emit(const ContactState());
}
