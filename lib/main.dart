import 'dart:async';
import 'package:chatapp/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:chatapp/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_database/firebase_database.dart';


class UserProvider extends ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  String? nickname;


  User? get user => _user;

  // 유저 로그인 데이터 체크
  User? checkCurrentUser() {
    _user = _auth.currentUser;
    notifyListeners();
    return _user;
  }

  // 파이어스토어 데이터 패치
   Future<void> fetchUserData() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance
          .collection('member')
          .doc(_user?.uid)
          .get();

      if (snapshot.exists) {
        nickname = snapshot.data()?['nickname'];
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  // 로그인 정보 전송
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = userCredential.user;
      await fetchUserData(); // Fetch user data after successful login
      notifyListeners(); // Notify listeners after successful login
    } catch (e) {
      print('Login failed: $e');
      throw e;
    }
  }

  // 로그아웃 정보 전송
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _user = null;
      nickname = null;
      // Schedule a callback after the frame has been built to notify listeners
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        notifyListeners();
      });
    } catch (e) {
      print('Logout failed: $e');
    }
  }
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyDvs_UqGL_Pd6lROCuAVzlWF2y5-J4mdNg",
        authDomain: "chatappdemo-928ba.firebaseapp.com",
        projectId: "chatappdemo-928ba",
        storageBucket: "chatappdemo-928ba.appspot.com",
        messagingSenderId: "321294404660",
        appId: "1:321294404660:web:365ea6afecb174fb890e61",
        measurementId: "G-LJYDTQ6BBJ"
    ),
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: IntroScreen(),
    );
  }
}

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  void initState() {
    super.initState();
    // 일정 시간이 지난 후에 메인 화면으로 이동하는 함수 호출
    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 500), // 애니메이션 지속 시간
          pageBuilder: (_, __, ___) => MyHomePage(), // 메인 화면으로 이동
          transitionsBuilder: (_, animation, __, child) {
            // 페이드 아웃 애니메이션 적용
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Text(
          'Community',
          style: TextStyle(
            fontSize: 40,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.black,
                offset: Offset(2,2),
                blurRadius: 4,
              )
            ],
          ),
          textAlign: TextAlign.center,
        ), // 인트로 화면에 표시될 내용
      ),
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
  // 각 게시판에 대한 글 목록을 가정한 리스트
  Map<String, List<String>> posts = {
    '자유게시판': ['글1', '글2', '글3'],
    '주식게시판': ['글4', '글5', '글6'],
    '유머게시판': ['글7', '글8', '글9'],
    '정치게시판': ['글10', '글11', '글12'],
    '질문게시판': ['글13', '글14', '글15'],
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.checkCurrentUser();
    });
  }

  void navigateToPage() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider._user != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => InformationPage()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    }
  }

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
              onPressed: navigateToPage,
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