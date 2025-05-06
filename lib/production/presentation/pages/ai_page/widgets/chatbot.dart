import 'package:ai_coach/production/presentation/pages/ai_page/widgets/loading_dialog_widget_ai.dart';
import 'package:ai_coach/production/presentation/pages/auth_page/widgets/loading_dialog_widget.dart';
import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:flutter/material.dart';

class ChatBot extends StatefulWidget {
  @override
  _ChatBotState createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final model =
      FirebaseVertexAI.instance.generativeModel(model: 'gemini-2.0-flash');
  List<Content> history = [];
  bool isAiAnswering = false;
  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        isAiAnswering = true;
      });
      final chat = model.startChat(history: history);
      Content prompt = Content.text(_messageController.text);
      final response = await chat.sendMessage(prompt);
      setState(() {
        _messages.addAll([
          {"role": "user", "text": "${_messageController.text}"},
          {"role": "model", "text": "${response.text!}"}
        ]);
        history.addAll([
          Content("user", [TextPart(_messageController.text)]),
          Content("model", [TextPart(response.text.toString())])
        ]);
        _messageController.clear();
        setState(() {
          isAiAnswering = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      height: 500,
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: Align(
                    alignment:
                        _messages.reversed.toList()[index]["role"] == "user"
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: 400,
                      ),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _messages.reversed.toList()[index]["text"]!,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Mesaj yazın...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    maxLines: null,
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: !isAiAnswering
                      ? IconButton(
                          icon: Icon(Icons.send, color: Colors.white),
                          onPressed: isAiAnswering ? null : _sendMessage,
                        )
                      : LoadingDialogAi(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
