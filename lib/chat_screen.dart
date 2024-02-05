import 'dart:async';

import 'package:ask_gpt/threedots.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'chatmessage.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  OpenAI? chatGPT;

  StreamSubscription? _subscription;
  bool _isTyping = false;

  @override
  void initState() {
    // TODO: implement initState
    chatGPT = OpenAI.instance;
    super.initState();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _sendMessage() {
    ChatMessage message = ChatMessage(text: _controller.text, sender: "user");

    setState(() {
      _messages.insert(0, message);
      _isTyping = true;
    });

    _controller.clear();

    final request = CompleteText(
        prompt: message.text, model: kChatGptTurbo0301Model, maxTokens: 2000);

    _subscription = chatGPT!
        .build(token: "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")
        .onCompletionStream(request: request)
        .listen((response) {
      Vx.log(response!.choices[0].text);
      ChatMessage botMessage =
          ChatMessage(text: response.choices[0].text, sender: "bot");

      setState(() {
        _isTyping = false;
        _messages.insert(0, botMessage);
      });
    });
  }

  Widget _buildTextComposer() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            onSubmitted: (value) => _sendMessage(),
            decoration: InputDecoration.collapsed(hintText: "Send a message"),
          ),
        ),
        IconButton(
            onPressed: () => _sendMessage(), icon: const Icon(Icons.send))
      ],
    ).px16().py16();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: VxAppBar(
            title: const Text("AskGPT").text.xl4.green100.bold.make(),
            centerTitle: true),
        body: SafeArea(
          child: Column(
            children: [
              Flexible(
                  child: ListView.builder(
                      reverse: true,
                      padding: Vx.m8,
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        return _messages[index];
                      })),
              if (_isTyping) ThreeDots(),
              const Divider(height: 1.0),
              Container(
                decoration: BoxDecoration(color: context.cardColor),
                child: _buildTextComposer(),
              )
            ],
          ),
        ));
  }
}
