import 'package:flutter/material.dart';
import 'main.dart';
import 'singuppage.dart';
import 'forgotpasswordpage.dart';
import 'package:one_flutter_app/spring/service.dart';
import 'package:shared_preferences/shared_preferences.dart';


// 로그인 페이지
class LoginPage extends StatelessWidget {
  // TextEditingController를 생성
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  Service service = Service();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.center,
          child: Text('Login'),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16.0),
          margin: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailController, // TextEditingController 할당
                decoration: InputDecoration(
                  hintText: '이메일',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: passwordController, // TextEditingController 할당
                decoration: InputDecoration(
                    hintText: '비밀번호',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock)),
                obscureText: true,
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      // 회원가입 버튼을 눌렀을 때 실행되는 동작
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpPage()),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                      child: Text(
                        '회원가입',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.0), // 버튼 간격 추가
                  GestureDetector(
                    onTap: () {
                      // 비밀번호 찾기 버튼을 눌렀을 때 실행되는 동작
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                      child: Text(
                        '비밀번호 찾기',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.0,
                        ),
                      ),
                    ),
                  ),
                  Spacer(), // 나머지 공간을 차지하도록 설정
                  GestureDetector(
                    onTap: () async {
                      // 로그인 버튼을 눌렀을 때 실행되는 동작
                      String email = emailController.text;
                      String password = passwordController.text;
                      var response = await service.login(email,password);
                      // 여기서 로그인 로직을 추가할 수 있습니다.
                      // 예를 들어, 서버로 전송하거나 유효성 검증을 수행하는 등

                      // 로그인 성공 시 홈 페이지로 이동
                      if (response != null && response.statusCode == 200) {
                        // 로그인 성공 시 홈 페이지로 이동
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.setString('email', email);

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => MyHomePage()),
                        );
                      }else{
                        print("로그인 실패");
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                      child: Text(
                        '로그인',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
