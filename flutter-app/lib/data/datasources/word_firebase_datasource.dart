import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/word_model.dart';

class WordFirebaseDatasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection = 'saved_words';

  Future<List<WordModel>> getSavedWords() async {
    final snapshot = await _firestore
        .collection(_collection)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => WordModel.fromFirestore(doc.data(), doc.id))
        .toList();
  }

  Future<void> saveWord(WordModel word) async {
    await _firestore.collection(_collection).add({
      ...word.toFirestore(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
