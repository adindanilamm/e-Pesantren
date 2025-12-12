import 'package:dartz/dartz.dart';
import '../entities/santri_entity.dart';

abstract class SantriRepository {
  Future<Either<String, List<SantriEntity>>> getSantriList();
  Future<Either<String, SantriEntity>> getSantriById(String id);
  Future<Either<String, void>> addSantri(SantriEntity santri);
  Future<Either<String, void>> updateSantri(SantriEntity santri);
  Future<Either<String, void>> deleteSantri(String id);
  Future<Either<String, List<SantriEntity>>> searchSantri(String query);
  Stream<List<SantriEntity>> getSantriListStream();
}
