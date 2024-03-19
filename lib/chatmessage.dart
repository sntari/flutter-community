import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
