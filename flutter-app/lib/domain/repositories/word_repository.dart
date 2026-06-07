import '../entities/word.dart';

abstract class WordRepository {
  Future<List<Word>> getWordsFromApi();
  Future<List<Word>> getSavedWords();
  Future<void> saveWord(Word word);
}
