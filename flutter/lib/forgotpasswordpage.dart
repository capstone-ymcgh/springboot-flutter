import 'package:flutter/material.dart';
import 'package:one_flutter_app/spring/service.dart';


class ForgotPasswordPage extends StatelessWidget {
  // TextEditingController를 생성
  final TextEditingController emailController = TextEditingController();
  Service service = new Service();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[300],
        title: Text('비밀번호 찾기'),
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
                  hintText: '이메일 주소 입력',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              SizedBox(height: 16.0),
              GestureDetector(
                onTap: () async{
                  // 입력된 이메일 주소를 가져와 변수에 저장
                  String email = emailController.text;
                  var success = await service.findPassword(email);
                  if (success) {
                    // 비밀번호를 성공적으로 찾은 경우의 로직 추가
                    print('비밀번호를 성공적으로 찾았습니다.');
                  } else {
                    // 비밀번호를 찾지 못한 경우의 로직 추가
                    print('비밀번호를 찾지 못했습니다.');
                  }
                  print('입력된 이메일: $email');
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child: Text(
                    '비밀번호 찾기',
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
