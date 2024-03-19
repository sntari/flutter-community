import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chatapp/chatmessage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  GlobalKey<AnimatedListState> _animListKey = GlobalKey<AnimatedListState>();
  TextEditingController _textEditingController = TextEditingController();

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
  }
}