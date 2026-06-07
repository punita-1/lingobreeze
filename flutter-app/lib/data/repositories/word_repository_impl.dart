import '../../domain/entities/word.dart';
import '../../domain/repositories/word_repository.dart';
import '../datasources/word_api_datasource.dart';
import '../datasources/word_firebase_datasource.dart';
import '../models/word_model.dart';

class WordRepositoryImpl implements WordRepository {
  final WordApiDatasource apiDatasource;
  final WordFirebaseDatasource firebaseDatasource;

  WordRepositoryImpl({
    required this.apiDatasource,
    required this.firebaseDatasource,
  });

  @override
  Future<List<Word>> getWordsFromApi() => apiDatasource.getWords();

  @override
  Future<List<Word>> getSavedWords() => firebaseDatasource.getSavedWords();

  @override
  Future<void> saveWord(Word word) {
    final model = WordModel(
      id: word.id,
      word: word.word,
      meaning: word.meaning,
      translation: word.translation,
    );
    return firebaseDatasource.saveWord(model);
  }
}
