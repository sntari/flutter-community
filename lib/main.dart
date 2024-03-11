import 'dart:async'; // Future와 Timer를 사용하기 위해 import

import 'dart:io';

import 'package:chatapp/home.dart';
import 'package:chatapp/intro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: IntroScreen(), // 앱 시작 시 인트로 화면을 표시
    );
  }
}

class MyHomePage extends StatelessWidget {

  final List<String> lables = ['자유게시판','주식게시판','유머게시판','정치게시판','질문게시판'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(Icons.accessible),
            Icon(Icons.add_card_outlined),
            Icon(Icons.login),
          ],
        ),
        backgroundColor: Colors.amber,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(onPressed: (){}, child: Text('공지사항')),
                TextButton(onPressed: (){}, child: Text('인기글')),
                DropdownButton<String>(
                  value: lables[0],
                  items: lables.map((String lable){
                    return DropdownMenuItem<String>(
                      value: lable,
                      child: Text(lable),
                    );
                  }).toList(),
                  onChanged: (String? newValue){
                    print('Selected option : $newValue');
                  },
                )
              ],
            ),
          ),
          // Add your content here
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.home_filled),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.key),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Homepage()),
                );
              },
              icon: Icon(Icons.chat),
            ),
          ],
        ),
      ),
    );
  }
}