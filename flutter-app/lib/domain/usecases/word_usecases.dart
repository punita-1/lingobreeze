import '../entities/word.dart';
import '../repositories/word_repository.dart';

class GetWordsFromApi {
  final WordRepository repository;
  GetWordsFromApi(this.repository);
  Future<List<Word>> call() => repository.getWordsFromApi();
}

class GetSavedWords {
  final WordRepository repository;
  GetSavedWords(this.repository);
  Future<List<Word>> call() => repository.getSavedWords();
}

class SaveWord {
  final WordRepository repository;
  SaveWord(this.repository);
  Future<void> call(Word word) => repository.saveWord(word);
}
