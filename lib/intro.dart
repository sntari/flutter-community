import 'dart:async';

import 'package:chatapp/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
      backgroundColor: Colors.amber,
      body: Center(
        child: Text(
          'Mungungdeng Community',
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