import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'main.dart';

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
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('대화방', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<void>(
        future: userProvider.fetchUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.done) {
            // 데이터 로드 완료 시 UI 표시
            return Column(
              children: [
                Expanded(
                  child: AnimatedList(
                    reverse: true,
                    key: _animListKey,
                    itemBuilder: (context, index, animation) =>
                        _buildItem(context, index, animation, userProvider.nickname),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _textEditingController,
                          decoration: InputDecoration(hintText: "메세지 입력창"),
                          onSubmitted: _handleSubmitted,
                          textInputAction: TextInputAction.send,
                          focusNode: _messageFocusNode,
                          autofocus: true,
                        ),
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      TextButton(
                        onPressed: () {
                          _handleSubmitted(_textEditingController.text);
                        },
                        child: Text('Send', style: TextStyle(color: Colors.white)),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            // 에러나 다른 상태에 대한 처리
            return Text('Error occurred'); // 예시로 에러가 발생했을 때 에러 메시지 표시
          }
        },
      ),
    );
  }

  Widget _buildItem(context, index, animation, String? nickname) {
    return ChatMessage(_chats[index], nickname: nickname, animation: animation);
  }

  void _handleSubmitted(String text) {
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
  final String? nickname;
  final Animation<double> animation;

  const ChatMessage(
    this.txt, {
    required this.animation,
    required this.nickname,
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
                child: Text(nickname?[0] ?? "N"),
              ),
              SizedBox(
                width: 16,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nickname ?? "Unknown", // Display the nickname
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
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
