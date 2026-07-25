import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:my_portfolio/presentation/common/base_status.dart';

part 'contact_state.freezed.dart';

@freezed
abstract class ContactState with _$ContactState {
  const factory ContactState({
    @Default(BaseStatus.initial()) BaseStatus submitStatus,
  }) = _ContactState;
}
