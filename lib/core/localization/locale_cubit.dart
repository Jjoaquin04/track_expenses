import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'locale_state.dart';

class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit() : super(const LocaleState(locale: Locale('es'))) {
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    final box = await Hive.openBox('user_config');
    final languageCode = box.get('language_code', defaultValue: 'es') as String;
    emit(LocaleState(locale: Locale(languageCode)));
  }

  Future<void> changeLocale(Locale locale) async {
    final box = await Hive.openBox('user_config');
    await box.put('language_code', locale.languageCode);
    emit(LocaleState(locale: locale));
  }
}
