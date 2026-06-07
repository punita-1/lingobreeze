import '../../domain/entities/word.dart';

class WordModel extends Word {
  const WordModel({
    required super.id,
    required super.word,
    required super.meaning,
    required super.translation,
  });

  factory WordModel.fromJson(Map<String, dynamic> json) {
    return WordModel(
      id: json['id']?.toString() ?? '',
      word: json['word'] ?? '',
      meaning: json['meaning'] ?? '',
      translation: json['translation'] ?? '',
    );
  }

  factory WordModel.fromFirestore(Map<String, dynamic> json, String docId) {
    return WordModel(
      id: docId,
      word: json['word'] ?? '',
      meaning: json['meaning'] ?? '',
      translation: json['translation'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'word': word,
      'meaning': meaning,
      'translation': translation,
    };
  }
}
