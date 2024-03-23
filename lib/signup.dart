import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _memberCollection = FirebaseFirestore.instance.collection('member');

  Future<void> _signUpWithEmailAndPassword() async {
    try {

      String password = passwordController.text.trim();
      RegExp upperCase = RegExp(r'[A-Z]');
      RegExp lowerCase = RegExp(r'[a-z]');
      RegExp digit = RegExp(r'[0-9]');
      RegExp specialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>]');

      if (!upperCase.hasMatch(password) ||
          !lowerCase.hasMatch(password) ||
          !digit.hasMatch(password) ||
          !specialChar.hasMatch(password)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '비밀번호는 영어 대문자, 소문자, 특수문자, 숫자를 모두 포함해야 합니다.'),
          ),
        );
        return; // Stop signup process if password validation fails
      }

     UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: idController.text.trim(),
        password: passwordController.text.trim(),
      );

      User? user = userCredential.user;
      if (user != null) {
        String uid = user.uid;

        await _memberCollection.doc(uid).set({
          'email': idController.text.trim(),
          'password': passwordController.text.trim(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('회원가입 성공')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('회원가입 실패')),
      );
    }
  }

  Future<void> _checkIdExistence() async {
    try {
      String email = idController.text.trim();

      // Query Firestore to check if any document exists with the provided email
      QuerySnapshot snapshot = await _memberCollection.where('email', isEqualTo: email).get();

      // If there are any documents with the provided email, it means the email is already in use
      setState(() {
        isIdAvailable = snapshot.docs.isEmpty;
      });

      print('isIdAvailable: $isIdAvailable');
    } catch (e) {
      setState(() {
        isIdAvailable = true; // Consider the email available in case of an error
      });

      print('Error checking ID existence: $e');
    }
  }

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
              onPressed: () async {
                // Perform duplicate check action
                await _checkIdExistence(); // Call the function to check for duplicates
                if (!isIdAvailable) {
                  // Display alert dialog if ID already exists
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('알림'),
                      content: Text('이미 존재하는 아이디입니다.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('확인'),
                        ),
                      ],
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('사용 가능한 아이디입니다.')),
                  );
                }
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
              onPressed: () async {
                // Perform signup action
                if (isIdAvailable &&
                    idController.text.isNotEmpty &&
                    passwordController.text.isNotEmpty &&
                    confirmPasswordController.text.isNotEmpty &&
                    passwordController.text == confirmPasswordController.text) {
                  // All fields are filled and passwords match
                  // Sign up with email and password
                  await _signUpWithEmailAndPassword();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('모든 필드를 입력하고 비밀번호가 일치하는지 확인하세요'),
                    ),
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