import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/word.dart';
import '../providers/word_provider.dart';

class AddWordSheet extends StatefulWidget {
  const AddWordSheet({super.key});

  @override
  State<AddWordSheet> createState() => _AddWordSheetState();
}

class _AddWordSheetState extends State<AddWordSheet> {
  final _formKey = GlobalKey<FormState>();
  final _wordController = TextEditingController();
  final _meaningController = TextEditingController();
  final _translationController = TextEditingController();

  // For API word suggestions
  Word? _selectedApiWord;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WordProvider>().loadApiWords();
    });
  }

  @override
  void dispose() {
    _wordController.dispose();
    _meaningController.dispose();
    _translationController.dispose();
    super.dispose();
  }

  void _fillFromApiWord(Word word) {
    setState(() {
      _selectedApiWord = word;
      _wordController.text = word.word;
      _meaningController.text = word.meaning;
      _translationController.text = word.translation;
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final word = Word(
      id: const Uuid().v4(),
      word: _wordController.text.trim(),
      meaning: _meaningController.text.trim(),
      translation: _translationController.text.trim(),
    );

    final provider = context.read<WordProvider>();
    final success = await provider.addWord(word);

    if (mounted) {
      if (success) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Word saved successfully!'),
            backgroundColor: Color(0xFF4CAF50),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save word. Please try again.'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(24, 16, 24, bottomPadding + 24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Add New Word',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D2D2D),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Fill in the fields or pick from suggestions below',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // API word suggestions
            Consumer<WordProvider>(
              builder: (context, provider, _) {
                if (provider.apiWords.isEmpty) return const SizedBox();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Quick Suggestions',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 36,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: provider.apiWords.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final w = provider.apiWords[index];
                          final isSelected = _selectedApiWord?.id == w.id;
                          return GestureDetector(
                            onTap: () => _fillFromApiWord(w),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected ? const Color(0xFF6C63FF) : const Color(0xFF6C63FF).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                w.word,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: isSelected ? Colors.white : const Color(0xFF6C63FF),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              },
            ),

            Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildField(_wordController, 'Word', 'e.g., Apple', Icons.abc),
                  const SizedBox(height: 12),
                  _buildField(_meaningController, 'Meaning', 'e.g., A round red fruit', Icons.lightbulb_outline),
                  const SizedBox(height: 12),
                  _buildField(_translationController, 'Translation', 'e.g., Manzana', Icons.translate),
                  const SizedBox(height: 24),
                  Consumer<WordProvider>(
                    builder: (context, provider, _) {
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: provider.isSaving ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6C63FF),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: provider.isSaving
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                )
                              : const Text('Save Word', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String label, String hint, IconData icon) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFF6C63FF)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF6C63FF), width: 2),
        ),
        filled: true,
        fillColor: const Color(0xFFF8F9FA),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '$label is required';
        }
        return null;
      },
    );
  }
}
