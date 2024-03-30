import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatPage extends StatefulWidget {

  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  GlobalKey<AnimatedListState> _animListKey = GlobalKey<AnimatedListState>();
  TextEditingController _textEditingController = TextEditingController();
  FocusNode _messageFocusNode = FocusNode();

  List<String> _chats = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('대화방', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
              child: AnimatedList(
                reverse: true,
                key: _animListKey,
                itemBuilder: _buildTtem,
              )),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(child: TextField(
                  controller: _textEditingController,
                  decoration: InputDecoration(hintText: "메세지 입력창"),
                  onSubmitted: _handleSubmitted,
                  textInputAction: TextInputAction.send,
                  focusNode: _messageFocusNode,
                  autofocus: true,
                )),
                SizedBox(
                  width: 8.0,
                ),
                TextButton(onPressed: () {
                  _handleSubmitted(_textEditingController.text);
                }, child: Text('Send', style: TextStyle(color: Colors.white)), style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue)),),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTtem(context, index, animation){
    return ChatMessage(_chats[index], animation: animation);
  }

  void _handleSubmitted(String text){
      Logger().d(text);
      _textEditingController.clear();
      _chats.insert(0, text);
      _animListKey.currentState?.insertItem(0);
      _messageFocusNode.requestFocus();
  }
}

// 이 아래론 채팅 메세지에 관련된 애니메이션 및 디자인
class ChatMessage extends StatelessWidget {
  final String txt;
  final Animation<double> animation;

  const ChatMessage(this.txt, {
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: FadeTransition(
        opacity: animation,
        child: SizeTransition(
          axisAlignment: -1.0,
          sizeFactor: animation,
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text("N"),
              ),
              SizedBox(width: 16,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("id or name", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(txt),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
