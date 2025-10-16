import 'package:equatable/equatable.dart';
import 'package:track_expenses/core/errors/failure.dart';
import 'package:dartz/dartz.dart';

abstract class Usecase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}
