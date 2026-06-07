import 'package:flutter/foundation.dart';
import '../../domain/entities/word.dart';
import '../../domain/usecases/word_usecases.dart';

enum WordLoadingState { idle, loading, success, error }

class WordProvider extends ChangeNotifier {
  final GetWordsFromApi getWordsFromApi;
  final GetSavedWords getSavedWords;
  final SaveWord saveWord;

  WordProvider({
    required this.getWordsFromApi,
    required this.getSavedWords,
    required this.saveWord,
  });

  List<Word> _savedWords = [];
  List<Word> _apiWords = [];
  WordLoadingState _state = WordLoadingState.idle;
  String _errorMessage = '';
  bool _isSaving = false;

  List<Word> get savedWords => _savedWords;
  List<Word> get apiWords => _apiWords;
  WordLoadingState get state => _state;
  String get errorMessage => _errorMessage;
  bool get isSaving => _isSaving;

  Future<void> loadSavedWords() async {
    _state = WordLoadingState.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      _savedWords = await getSavedWords();
      _state = WordLoadingState.success;
    } catch (e) {
      _state = WordLoadingState.error;
      _errorMessage = 'Failed to load words. Please check your connection.';
    }
    notifyListeners();
  }

  Future<void> loadApiWords() async {
    try {
      _apiWords = await getWordsFromApi();
      notifyListeners();
    } catch (e) {
      // API words load failure — not critical for the main screen
      _apiWords = [];
      notifyListeners();
    }
  }

  Future<bool> addWord(Word word) async {
    _isSaving = true;
    notifyListeners();

    try {
      await saveWord(word);
      await loadSavedWords();
      _isSaving = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isSaving = false;
      notifyListeners();
      return false;
    }
  }
}
