import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nostra/core/localization/locale_cubit.dart';
import 'package:nostra/core/themes/app_color.dart';
import 'package:nostra/l10n/app_localizations.dart';

class LanguageSettingsScreen extends StatelessWidget {
  const LanguageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        foregroundColor: Colors.white,
        title: Text(
          l10n.language,
          style: const TextStyle(
            fontFamily: 'SEGOE_UI',
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: BlocBuilder<LocaleCubit, LocaleState>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _LanguageTile(
                      title: l10n.spanish,
                      subtitle: 'Español',
                      locale: const Locale('es'),
                      currentLocale: state.locale,
                      onTap: () {
                        context.read<LocaleCubit>().changeLocale(
                          const Locale('es'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.languageChanged),
                            duration: const Duration(seconds: 2),
                            backgroundColor: AppColor.primary,
                          ),
                        );
                      },
                    ),
                    const Divider(height: 1),
                    _LanguageTile(
                      title: l10n.english,
                      subtitle: 'English',
                      locale: const Locale('en'),
                      currentLocale: state.locale,
                      onTap: () {
                        context.read<LocaleCubit>().changeLocale(
                          const Locale('en'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.languageChanged),
                            duration: const Duration(seconds: 2),
                            backgroundColor: AppColor.primary,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Locale locale;
  final Locale currentLocale;
  final VoidCallback onTap;

  const _LanguageTile({
    required this.title,
    required this.subtitle,
    required this.locale,
    required this.currentLocale,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = locale.languageCode == currentLocale.languageCode;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: CircleAvatar(
        backgroundColor: isSelected ? AppColor.primary : Colors.grey[300],
        child: Text(
          locale.languageCode.toUpperCase(),
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontWeight: FontWeight.bold,
            fontFamily: 'SEGOE_UI',
          ),
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'SEGOE_UI',
          fontSize: 16,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? AppColor.primary : Colors.black87,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontFamily: 'SEGOE_UI',
          fontSize: 14,
          color: Colors.grey[600],
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check_circle, color: AppColor.primary, size: 28)
          : Icon(Icons.circle_outlined, color: Colors.grey[400], size: 28),
      onTap: onTap,
    );
  }
}
