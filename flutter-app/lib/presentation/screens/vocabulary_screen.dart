import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/word_provider.dart';
import '../widgets/word_card.dart';
import '../widgets/add_word_sheet.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/error_state_widget.dart';

class VocabularyScreen extends StatefulWidget {
  const VocabularyScreen({super.key});

  @override
  State<VocabularyScreen> createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends State<VocabularyScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WordProvider>().loadSavedWords();
    });
  }

  void _showAddWordSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddWordSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'My Vocabulary',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF6C63FF),
        elevation: 0,
        centerTitle: false,
      ),
      body: Consumer<WordProvider>(
        builder: (context, provider, _) {
          // Loading state
          if (provider.state == WordLoadingState.loading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Color(0xFF6C63FF)),
                  SizedBox(height: 16),
                  Text('Loading your words...', style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          // Error state
          if (provider.state == WordLoadingState.error) {
            return ErrorStateWidget(
              message: provider.errorMessage,
              onRetry: () => provider.loadSavedWords(),
            );
          }

          // Empty state
          if (provider.savedWords.isEmpty) {
            return EmptyStateWidget(onAdd: _showAddWordSheet);
          }

          // Words list
          return RefreshIndicator(
            color: const Color(0xFF6C63FF),
            onRefresh: () => provider.loadSavedWords(),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: provider.savedWords.length,
              itemBuilder: (context, index) {
                return WordCard(word: provider.savedWords[index]);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddWordSheet,
        backgroundColor: const Color(0xFF6C63FF),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Word', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
