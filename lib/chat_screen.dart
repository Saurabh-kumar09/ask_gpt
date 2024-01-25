import 'dart:async';

import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chatGPT = OpenAI.instance.build();
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
    });

    _controller.clear();

    final request = CompleteText(
        prompt: message.text, model: kChatGptTurbo0301Model, maxTokens: 200);

    _subscription = chatGPT!
        .builder("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",
            OrgId: "")
        .onCompleteStream(request: request)
        .listen((response) {
      Vx.log(response!.choices[0].text);
      ChatMessage botMessage =
          ChatMessage(text: response.choices[0].text, sender: "bot");
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
              Container(
                decoration: BoxDecoration(color: context.cardColor),
                child: _buildTextComposer(),
              )
            ],
          ),
        ));
  }
}
