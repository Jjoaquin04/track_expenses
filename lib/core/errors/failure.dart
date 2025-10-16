import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'No se pudieron guardar los datos']);
}

class ValidationFailure extends Failure {
  const ValidationFailure([
    super.message = 'Los datos ingresados no son válidos',
  ]);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([
    super.message = 'No se encontró el elemento solicitado',
  ]);
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'Ocurrió un error inesperado']);
}
