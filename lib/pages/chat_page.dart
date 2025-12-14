import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../consts.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // 1. Inisialisasi Model Gemini
  // 'gemini-1.5-flash' adalah model yang cepat dan gratis (free tier)
  late final GenerativeModel _model;

  // 2. Chat Session (Menyimpan riwayat percakapan agar AI ingat konteks)
  late final ChatSession _chatSession;

  // Controller untuk Input Teks
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _model = GenerativeModel(model: 'gemini-2.5-flash', apiKey: GEMINI_API_KEY);
    // Coba panggil startChat dengan systemInstruction jika tersedia (via dynamic).
    // Jika tidak tersedia, fallback ke startChat() biasa.
    try {
      final dynModel = _model as dynamic;
      final dynChat = dynModel.startChat(
        systemInstruction: Content.text(academicAssistantPrompt),
      );
      _chatSession = dynChat as ChatSession;
    } catch (e) {
      // Fallback: start chat biasa
      _chatSession = _model.startChat();
      // Jika implementasi SDK mendukung mengirim pesan system via sendMessage with role,
      // coba secara dinamis — jika gagal, tidak mengganggu aplikasi.
      try {
        final dynChat = _chatSession as dynamic;
        dynChat.sendMessage(
          Content.text(academicAssistantPrompt),
          role: 'system',
        );
      } catch (_) {}
    }
    // Tidak mengirim system message di init; akan sertakan prompt ketika kirim pesan
  }

  // Fungsi Mengirim Pesan
  Future<void> _sendMessage() async {
    final message = _textController.text;
    if (message.isEmpty) return;

    setState(() {
      _isLoading = true; // Tampilkan loading
    });

    try {
      // Kirim pesan ke user UI dulu (Optimistic UI)
      _textController.clear();

      // Kirim ke Gemini dan tunggu respon
      // Sertakan prompt persona di awal pesan agar model berperilaku sebagai Academic Assistant
      final promptMessage = '$academicAssistantPrompt\n\nUser: $message';
      final response = await _chatSession.sendMessage(
        Content.text(promptMessage),
      );

      // Respon otomatis masuk ke history _chatSession
      // Kita hanya perlu rebuild UI agar history tampil
      if (response.text == null) {
        _showError('No response from API.');
        return;
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      setState(() {
        _isLoading = false; // Matikan loading
      });
      _scrollToBottom();
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _scrollToBottom() {
    // Scroll otomatis ke pesan terakhir
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Sembunyikan pesan `system` supaya prompt sistem tidak terlihat di UI
    final messages = _chatSession.history
        .where((content) => content.role != 'system')
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Academic Assistant AI'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // 1. LIST PESAN (Expanded agar memenuhi layar)
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final content = messages[index];
                final text = content.parts
                    .whereType<TextPart>()
                    .map<String>((e) => e.text)
                    .join('');

                // Cek apakah ini pesan dari User atau Model (Gemini)
                final isUser = content.role == 'user';

                return Align(
                  alignment: isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 10,
                    ),
                    padding: const EdgeInsets.all(10),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.deepPurple[100] : Colors.grey[200],
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(12),
                        topRight: const Radius.circular(12),
                        bottomLeft: isUser
                            ? const Radius.circular(12)
                            : Radius.zero,
                        bottomRight: isUser
                            ? Radius.zero
                            : const Radius.circular(12),
                      ),
                    ),
                    // MarkdownBody membuat teks tebal/kode jadi rapi
                    child: MarkdownBody(data: text),
                  ),
                );
              },
            ),
          ),

          // 2. LOADING INDICATOR
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: LinearProgressIndicator(),
            ),

          // 3. INPUT FIELD AREA
          Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Tanya sesuatu...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  color: Colors.deepPurple,
                  onPressed: _isLoading ? null : _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
