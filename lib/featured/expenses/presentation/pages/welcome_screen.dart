import 'package:flutter/material.dart';
import 'package:track_expenses/core/themes/app_color.dart';
import 'package:track_expenses/core/utils/user_config.dart';
import 'package:track_expenses/featured/expenses/presentation/pages/expenses_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _initialBalanceController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _initialBalanceController.dispose();
    super.dispose();
  }

  void _handleContinue() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final initialBalance =
          double.tryParse(_initialBalanceController.text) ?? 0.0;

      // Guardar configuración
      await UserConfig.saveUserConfig(
        name: name,
        initialBalance: initialBalance,
      );

      // Navegar a la pantalla principal
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const ExpensesScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 60,
              left: 24,
              right: 24,
              bottom: 24,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Icono/Logo
                  Icon(
                    Icons.account_balance_wallet,
                    size: 100,
                    color: AppColor.primary,
                  ),
                  const SizedBox(height: 40),

                  // Título
                  const Text(
                    '¡Bienvenido!',
                    style: TextStyle(
                      fontFamily: 'SEGOE_UI',
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: AppColor.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  // Subtítulo
                  Text(
                    'Configura tu perfil para comenzar',
                    style: TextStyle(
                      fontFamily: 'SEGOE_UI',
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),

                  // Campo: Nombre
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Tu nombre',
                      hintText: 'Ej: Juan Pérez',
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Por favor ingresa tu nombre';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Campo: Balance inicial
                  TextFormField(
                    controller: _initialBalanceController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Balance inicial',
                      hintText: 'Ej: 1000.00',
                      prefixIcon: const Icon(Icons.euro),
                      suffixText: '€',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      helperText: 'Cantidad de dinero con la que comienzas',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Por favor ingresa un balance inicial';
                      }
                      final number = double.tryParse(value);
                      if (number == null) {
                        return 'Ingresa un número válido';
                      }
                      if (number < 0) {
                        return 'El balance no puede ser negativo';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 40),

                  // Botón continuar
                  ElevatedButton(
                    onPressed: _handleContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: const Text(
                      'Comenzar',
                      style: TextStyle(
                        fontFamily: 'SEGOE_UI',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
