import 'package:chatapp/signup.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isLoggedIn = false; // Track login state
  TextEditingController idController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
          onPressed: () {
            // Perform login action (dummy implementation)
            setState(() {
              isLoggedIn = true;
            });
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
          onPressed: () {
            // Perform logout action
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