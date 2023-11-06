import 'package:clean_architecture/core/errors/failure.dart';
import 'package:dartz/dartz.dart';

typedef ResultFuture<T> = Future<Either<Failure, T>>;

typedef ResultVoid = Future<void>;

typedef DataMap = Map<String, dynamic>;
