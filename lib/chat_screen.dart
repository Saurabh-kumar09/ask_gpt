import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Widget _buildTextComposer() {
    return Row(
      children: [
        const Expanded(
          child: TextField(
            decoration: InputDecoration.collapsed(hintText: "Send a message"),
          ),
        ),
        IconButton(onPressed: () {}, icon: const Icon(Icons.send))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("AskGPT")),
        body: Column(
          children: [
            Container(
              decoration: BoxDecoration(color: context.cardColor),
              child: _buildTextComposer(),
            )
          ],
        ));
  }
}
