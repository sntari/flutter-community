import 'package:chatapp/home.dart';
import 'package:chatapp/intro.dart';
import 'package:chatapp/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main(){
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('중장년 커뮤니티'),
            Padding(
              padding: const EdgeInsets.only(right: 10.0), // Adjust the padding as needed
              child: Icon(Icons.add_alert),
            ),
          ],
        ),
        backgroundColor: Colors.amber,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    // '공지사항' 버튼을 누를 때 선택된 레이블을 업데이트
                    setSelectedLabel('공지사항');
                  },
                  child: Text('공지사항'),
                ),
                TextButton(
                  onPressed: () {
                    // '인기글' 버튼을 누를 때 선택된 레이블을 업데이트
                    setSelectedLabel('인기글');
                  },
                  child: Text('인기글'),
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
                    // 선택된 레이블을 변경하는 함수 호출
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
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10.0),
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