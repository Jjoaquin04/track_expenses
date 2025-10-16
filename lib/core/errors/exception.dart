import 'package:equatable/equatable.dart';

class CacheException extends Equatable {
  final String message;

  const CacheException(this.message);

  @override
  List<Object?> get props => [message];
}

class StorageException extends Equatable {
  final String message;

  const StorageException([this.message = "Error al acceder al almacenamiento"]);

  @override
  List<Object?> get props => [message];
}
