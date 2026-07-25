import 'package:freezed_annotation/freezed_annotation.dart';

part 'json_to_dart_state.freezed.dart';

@freezed
abstract class JsonToDartState with _$JsonToDartState {
  const factory JsonToDartState({@Default('') String output}) =
      _JsonToDartState;
}
