import 'package:chatapp/signup.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isLoggedIn = false; // Track login state
  TextEditingController idController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(isLoggedIn ? '정보 수정' : '로그인', style: TextStyle(color: Colors.white)),
        actions: [
          if (!isLoggedIn)
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
        child: isLoggedIn ? _buildLoggedInScreen() : _buildLoginScreen(),
      ),
    );
  }

  Widget _buildLoginScreen() {
    return Column(
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
              UserCredential userCredential = await _auth.signInWithEmailAndPassword(
                email: idController.text.trim(),
                password: passwordController.text.trim(),
              );
              setState(() {
                isLoggedIn = true;
              });
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
    );
  }

  Widget _buildLoggedInScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage('assets/ee.jpg'), // Replace 'assets/profile_picture.png' with your image path
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () async {
            await _auth.signOut();
            setState(() {
              isLoggedIn = false;
            });
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
    );
  }
}