import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:my_portfolio/data/errors/app_failure.dart';

part 'base_status.freezed.dart';

/// Reusable async status union used inside Cubit states — matches the team
/// reference app so UI exhaustively handles loading/success/failure.
@freezed
sealed class BaseStatus<T extends Object?> with _$BaseStatus<T> {
  const BaseStatus._();

  const factory BaseStatus.initial({T? value}) = Initial<T>;
  const factory BaseStatus.loading({T? value}) = Loading<T>;
  const factory BaseStatus.success({T? value}) = Success<T>;
  const factory BaseStatus.valid({T? value}) = Valid<T>;
  const factory BaseStatus.invalid({T? value}) = Invalid<T>;
  const factory BaseStatus.failure(AppFailure error) = Failure<T>;

  bool get isInitial => this is Initial<T>;
  bool get isLoading => this is Loading<T>;
  bool get isSuccess => this is Success<T>;
  bool get isValid => this is Valid<T>;
  bool get isInvalid => this is Invalid<T>;
  bool get isFailure => this is Failure<T>;
}
