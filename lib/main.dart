import 'package:chatapp/home.dart';
import 'package:chatapp/intro.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:chatapp/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() async{
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: IntroScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> labels = ['자유게시판','주식게시판','유머게시판','정치게시판','질문게시판'];
  String selectedLabel = '';
  String noticeText = '';
  String popularText = '';

  // 각 게시판에 대한 글 목록을 가정한 리스트
  Map<String, List<String>> posts = {
    '자유게시판': ['글1', '글2', '글3'],
    '주식게시판': ['글4', '글5', '글6'],
    '유머게시판': ['글7', '글8', '글9'],
    '정치게시판': ['글10', '글11', '글12'],
    '질문게시판': ['글13', '글14', '글15'],
  };

  // 선택된 레이블을 변경하는 함수
  void setSelectedLabel(String newLabel) {
    setState(() {
      selectedLabel = newLabel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('커뮤니티', style: TextStyle(color: Colors.white)),
            Icon(Icons.notifications, color: Colors.white),
          ],
        ),
      ),
      body : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    setSelectedLabel('공지사항');
                  },
                  child: Text('공지사항', style: TextStyle(color: Colors.blue)),
                ),
                TextButton(
                  onPressed: () {
                    setSelectedLabel('인기글');
                  },
                  child: Text('인기글', style: TextStyle(color: Colors.blue)),
                ),
                PopupMenuButton<String>(
                  initialValue: labels[0],
                  itemBuilder: (BuildContext context) {
                    return labels.map((String label) {
                      return PopupMenuItem<String>(
                        value: label,
                        child: Text(label),
                      );
                    }).toList();
                  },
                  onSelected: (String? newValue) {
                    setSelectedLabel(newValue!);
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              selectedLabel.isNotEmpty ? selectedLabel : '',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (selectedLabel.isNotEmpty) ...[
            Expanded(
              child: ListView.builder(
                itemCount: posts[selectedLabel]?.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          posts[selectedLabel]?[index] ?? '',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          '게시판: $selectedLabel',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),);
              },
              icon: Icon(Icons.key),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                MaterialPageRoute(builder: (context) => ChatPage()),);
              },
              icon: Icon(Icons.chat),
            ),
          ],
        ),
      ),
    );
  }
}