import 'package:flutter/material.dart';
import 'package:one_flutter_app/spring/service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'loginpage.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController businessCodeController = TextEditingController();

  String userType = '일반 사용자'; // 기본 사용자 유형을 '일반 사용자'로 설정
  Service service = Service();
  void _signUp() {
    // 입력된 값을 가져와 변수에 저장
    String email = emailController.text;
    String nickname = nicknameController.text;
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;
    String businessCode = businessCodeController.text;

    // 유효성 검사
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('이메일을 입력해주세요.'),
        ),
      );
      return;
    }

    if (nickname.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('닉네임을 입력해주세요.'),
        ),
      );
      return;
    }

    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('비밀번호를 입력해주세요.'),
        ),
      );
      return;
    }

    if (confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('비밀번호 확인을 입력해주세요.'),
        ),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('비밀번호와 비밀번호 확인이 일치하지 않습니다.'),
        ),
      );
      return;
    }

    if (userType == '도매상' && businessCode.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('사업자 코드를 입력해주세요.'),
        ),
      );
      return;
    }

    print('UserType: $userType, Email: $email, Nickname: $nickname, Password: $password, ConfirmPassword: $confirmPassword, BusinessCode: $businessCode');

    // 모든 값이 유효한 경우, 로그인 페이지로 이동
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double paddingHeight = screenHeight * 0.1;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.orange[300],
        title: Text('회원가입'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: paddingHeight),
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
                controller: emailController,
                decoration: InputDecoration(
                  hintText: '이메일',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: nicknameController,
                decoration: InputDecoration(
                  hintText: '닉네임',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.account_circle),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  hintText: '비밀번호',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: confirmPasswordController,
                decoration: InputDecoration(
                  hintText: '비밀번호 확인',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              SizedBox(height: 16.0),
              DropdownButton<String>(
                value: userType,
                onChanged: (String? newValue) {
                  setState(() {
                    userType = newValue!;
                  });
                },
                items: <String>['일반 사용자', '도매상']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              Visibility(
                visible: userType == '도매상',
                child: Column(
                  children: [
                    SizedBox(height: 16.0),
                    TextField(
                      controller: businessCodeController,
                      decoration: InputDecoration(
                        hintText: '사업자 코드',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.business),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              GestureDetector(
                onTap:() async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setString('nickname', nicknameController.text);
                  await service.saveUser(emailController.text, nicknameController.text, passwordController.text, userType, businessCodeController.text);
                  _signUp();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child: Text(
                    '회원가입',
                    style: TextStyle(color: Colors.white, fontSize: 16.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
