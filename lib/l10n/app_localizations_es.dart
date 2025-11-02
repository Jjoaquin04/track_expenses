// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get welcomeTitle => '¡Bienvenido!';

  @override
  String get welcomeSubtitle => 'Configura tu perfil para comenzar';

  @override
  String get yourName => 'Tu nombre';

  @override
  String get yourNameHint => 'Ej: Juan Pérez';

  @override
  String get initialBalance => 'Balance inicial';

  @override
  String get initialBalanceHint => 'Ej: 1000.00';

  @override
  String get initialBalanceHelper => 'Cantidad de dinero con la que comienzas';

  @override
  String get continueButton => 'Comenzar';

  @override
  String get pleaseEnterName => 'Por favor ingresa tu nombre';

  @override
  String get pleaseEnterBalance => 'Por favor ingresa un balance inicial';

  @override
  String get enterValidNumber => 'Ingresa un número válido';

  @override
  String get balanceCannotBeNegative => 'El balance no puede ser negativo';

  @override
  String get hello => 'Hola';

  @override
  String get total => 'Total';

  @override
  String get personalMovementTracking =>
      'Seguimiento de Movimientos Personales';

  @override
  String get expenses => 'Gastos';

  @override
  String get totalExpenses => 'Gastos Totales';

  @override
  String get totalIncome => 'Ingresos Totales';

  @override
  String get currentBalance => 'Balance Actual';

  @override
  String get noExpensesYet => 'Aún no hay gastos';

  @override
  String get startAddingExpenses =>
      'Comienza a agregar tus gastos usando el botón +';

  @override
  String get errorLoadingExpenses => 'Error al cargar los gastos';

  @override
  String get retryButton => 'Reintentar';

  @override
  String get fixed => 'Fijo';

  @override
  String get dailyExpense => 'Gasto diario';

  @override
  String get newTransaction => 'Nueva Transacción';

  @override
  String get type => 'Tipo';

  @override
  String get expense => 'Gasto';

  @override
  String get income => 'Ingreso';

  @override
  String get category => 'Categoría';

  @override
  String get name => 'Nombre';

  @override
  String get nameHint => 'Ej: Supermercado';

  @override
  String get amount => 'Monto';

  @override
  String get amountHint => 'Ej: 25.50';

  @override
  String get date => 'Fecha';

  @override
  String get dateHint => 'Selecciona una fecha';

  @override
  String get isFixedExpense => '¿Es un gasto fijo?';

  @override
  String get saveButton => 'Guardar';

  @override
  String get pleaseEnterValidAmount => 'Por favor ingresa un monto válido';

  @override
  String get pleaseSelectDate => 'Por favor selecciona una fecha';

  @override
  String get pleaseEnterTransactionName =>
      'Por favor ingresa un nombre para la transacción';

  @override
  String itemsSelected(int count) {
    return '$count seleccionados';
  }

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Eliminar';

  @override
  String get confirmDelete => 'Confirmar eliminación';

  @override
  String get confirmDeleteMessage =>
      '¿Estás seguro de que deseas eliminar los gastos seleccionados?';

  @override
  String get no => 'No';

  @override
  String get yes => 'Sí';

  @override
  String get previousMonths => 'Meses Anteriores';

  @override
  String monthYear(String month, int year) {
    return '$month $year';
  }

  @override
  String get noDataForMonth => 'No hay datos para este mes';

  @override
  String get expensesByCategory => 'Gastos por Categoría';

  @override
  String get incomeByCategory => 'Ingresos por Categoría';

  @override
  String get january => 'Enero';

  @override
  String get february => 'Febrero';

  @override
  String get march => 'Marzo';

  @override
  String get april => 'Abril';

  @override
  String get may => 'Mayo';

  @override
  String get june => 'Junio';

  @override
  String get july => 'Julio';

  @override
  String get august => 'Agosto';

  @override
  String get september => 'Septiembre';

  @override
  String get october => 'Octubre';

  @override
  String get november => 'Noviembre';

  @override
  String get december => 'Diciembre';

  @override
  String get categoryFood => 'Comida';

  @override
  String get categoryTransport => 'Transporte';

  @override
  String get categoryEntertainment => 'Entretenimiento';

  @override
  String get categoryHealth => 'Salud';

  @override
  String get categoryEducation => 'Educación';

  @override
  String get categoryClothing => 'Ropa';

  @override
  String get categoryOther => 'Otros';

  @override
  String get categorySalary => 'Salario';

  @override
  String get categoryBonus => 'Bonificación';

  @override
  String get categoryInvestment => 'Inversión';

  @override
  String get categoryGift => 'Regalo';

  @override
  String get categoryOtherIncome => 'Otros Ingresos';

  @override
  String get settings => 'Configuración';

  @override
  String get language => 'Idioma';

  @override
  String get selectLanguage => 'Seleccionar Idioma';

  @override
  String get english => 'Inglés';

  @override
  String get spanish => 'Español';

  @override
  String get languageChanged => 'Idioma cambiado exitosamente';

  @override
  String get expenseAddedSuccess => 'Gasto agregado exitosamente';

  @override
  String get expenseDeletedSuccess => 'Gasto(s) eliminado(s) exitosamente';

  @override
  String get errorOccurred => 'Ocurrió un error';

  @override
  String get fixedTransactionInfo => 'Información de movimiento fijo';

  @override
  String get fixedTransactionDescription =>
      'Este gasto está marcado como fijo. Los movimientos fijos son aquellos que se repiten mensualmente, es decir, se añaden automáticamente.';

  @override
  String get startAddingTransactions =>
      'Comienza añadiendo un nuevo gasto o ingreso';

  @override
  String get noTransactionsRecorded => 'No hay movimientos registrados';

  @override
  String get unknownState => 'Estado desconocido';
}
