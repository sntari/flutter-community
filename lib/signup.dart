import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController idController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool isIdAvailable = true; // Track whether the entered ID is available

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('회원가입', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: idController,
              decoration: InputDecoration(
                labelText: 'ID',
                border: OutlineInputBorder(),
                suffixIcon: isIdAvailable
                    ? null
                    : Icon(
                  Icons.error,
                  color: Colors.red,
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Perform duplicate check action
                // This is a dummy implementation, replace it with actual logic
                setState(() {
                  isIdAvailable = idController.text.isNotEmpty;
                });
              },
              child: Text('중복 확인'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 10),
            TextField(
              controller: confirmPasswordController,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Perform signup action
                // This is a dummy implementation, replace it with actual logic
                if (idController.text.isNotEmpty &&
                    passwordController.text.isNotEmpty &&
                    confirmPasswordController.text.isNotEmpty &&
                    passwordController.text == confirmPasswordController.text) {
                  // All fields are filled and passwords match
                  // Add your signup logic here
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('회원가입 성공')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('모든 필드를 입력하고 비밀번호가 일치하는지 확인하세요')),
                  );
                }
              },
              child: Text('가입'),
            ),
          ],
        ),
      ),
    );
  }
}