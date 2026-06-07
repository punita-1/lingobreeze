import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'data/datasources/word_api_datasource.dart';
import 'data/datasources/word_firebase_datasource.dart';
import 'data/repositories/word_repository_impl.dart';
import 'domain/usecases/word_usecases.dart';
import 'presentation/providers/word_provider.dart';
import 'presentation/screens/vocabulary_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const LingoBreezeApp());
}

class LingoBreezeApp extends StatelessWidget {
  const LingoBreezeApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Dependency injection
    final apiDatasource = WordApiDatasource();
    final firebaseDatasource = WordFirebaseDatasource();
    final repository = WordRepositoryImpl(
      apiDatasource: apiDatasource,
      firebaseDatasource: firebaseDatasource,
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => WordProvider(
            getWordsFromApi: GetWordsFromApi(repository),
            getSavedWords: GetSavedWords(repository),
            saveWord: SaveWord(repository),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'LingoBreeze',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6C63FF)),
          useMaterial3: true,
          fontFamily: 'Roboto',
        ),
        home: const VocabularyScreen(),
      ),
    );
  }
}
