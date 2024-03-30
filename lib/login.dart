import 'package:chatapp/signup.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoginPage();
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // 컨트롤러들
  TextEditingController idController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 객체와 값들을 담을 공간들
  User? _user; // Firebase User 객체를 저장할 변수
  bool isLoggedIn = false;
  String? nickname;

  // 다른 페이지에 갔다와도 로그인이 유지되게끔 위젯 실행시 체크
  @override
  void initState() {
    super.initState();
    _checkCurrentUser();
  }

  // 사용자의 로그인을 계속 유지할  수 있게 현재상태 체크
  void _checkCurrentUser() {
    _user = _auth.currentUser;
    if (_user != null) {
      setState(() {
        isLoggedIn = true;
        _fetchUserData();
      });
    } else {
      setState(() {
        isLoggedIn = false;
      });
    }
  }

  // auth가 아닌 데이터베이스의 값들을 가져옴
  Future<void> _fetchUserData() async {
    try {
      // Get the user document from Firestore
      DocumentSnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance.collection('member')
          .doc(_user?.uid)
          .get();

      if (snapshot.exists) {
        // Extract the nickname from the snapshot
        setState(() {
          nickname = snapshot.data()?['nickname'];
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoggedIn ? InformationPage() : Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('로그인', style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignUp()),);
            },
            child: Text(
              '회원가입',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: idController,
              decoration: InputDecoration(
                labelText: 'ID',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Perform login action
                try {
                  UserCredential userCredential = await _auth
                      .signInWithEmailAndPassword(
                    email: idController.text.trim(),
                    password: passwordController.text.trim(),
                  );
                  if (userCredential.user != null) {
                    setState(() {
                      isLoggedIn = true;
                      _checkCurrentUser(); // Call _checkCurrentUser after successful login
                    });
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('로그인 실패'),
                    ),
                  );
                }
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }

  Widget InformationPage() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('회원 정보', style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
               CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/ee.jpg'),
              ),
            SizedBox(height: 20),
            Text(
              '닉네임: ${nickname ?? 'Unknown'}',
              style: TextStyle(fontSize: 18),
            ), // 사용자 UID 표시
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _auth.signOut();
                setState(() {
                  isLoggedIn = false;
                });
                _checkCurrentUser();
              },
              child: Text('Logout'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Navigate to the information modification screen
              },
              child: Text('Edit Information'),
            ),
          ],
        ),
      ),
    );
  }
}
