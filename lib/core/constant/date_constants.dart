import 'package:track_expenses/l10n/app_localizations.dart';

String getMonthName(int month, AppLocalizations l10n) {
  switch (month) {
    case 1:
      return l10n.january;
    case 2:
      return l10n.february;
    case 3:
      return l10n.march;
    case 4:
      return l10n.april;
    case 5:
      return l10n.may;
    case 6:
      return l10n.june;
    case 7:
      return l10n.july;
    case 8:
      return l10n.august;
    case 9:
      return l10n.september;
    case 10:
      return l10n.october;
    case 11:
      return l10n.november;
    case 12:
      return l10n.december;
    default:
      return '';
  }
}
