part of 'settings_cubit.dart';

@freezed
abstract class SettingsState with _$SettingsState {
  const factory SettingsState({required bool soundEnabled, required bool vibrationEnabled}) =
      _SettingsState;
}
