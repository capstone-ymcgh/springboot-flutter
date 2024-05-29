import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Service{
  String serverurl = 'http://localhost:8000';
  String getServerurl(){
    return serverurl;
  }
  Future<http.Response?> saveUser(
      String email, String nickname, String password, String usertype, String businesscode) async {
    try {
      var uri = Uri.parse("$serverurl/api/signup");
      Map<String,String> headers = {"Content-Type": "application/json"};

      Map data = {
        'email' : '$email',
        'nickname' : '$nickname',
        'password' : '$password',
        'usertype' : '$usertype',
        'businesscode' : '$businesscode'
      };
      var body = json.encode(data);
      var response = await http.post(uri,headers: headers, body: body);

      if (response.statusCode == 200) {
        // 서버로부터 성공적인 응답을 받았을 때의 동작
        print("회원가입 성공");
      } else {
        // 서버로부터 실패한 응답을 받았을 때의 동작
        print("회원가입 실패: ${response.body}");
      }
      print("${response.body}");
      return response;
    } catch (error) {
      print("에러 발생: $error");
      return null; // 또는 예외 처리를 진행할 수 있습니다.
    }
  }

  Future<http.Response?> login(String email, String password) async {
    try {
      var uri = Uri.parse("$serverurl/api/login");
      Map<String,String> headers = {"Content-Type": "application/json"};

      Map data = {
        'email' : '$email',
        'password' : '$password',
      };

      var body = json.encode(data);
      var response = await http.post(uri,headers: headers, body: body);

      if (response.statusCode == 200) {
        print("로그인 성공");
      } else {
        print("로그인 실패: ${response.body}");
      }

      return response;
    } catch (error) {
      print("에러 발생: $error");
      return null;
    }
  }

  Future<bool> findPassword(String email) async {
    try {
      var uri = Uri.parse("$serverurl/api/findpassword?email=$email");

      var response = await http.get(uri);

      if (response.statusCode == 200) {
        print("비밀번호 찾기 성공: ${response.body}");
        return true; // 비밀번호를 성공적으로 찾았음을 반환
      } else {
        print("비밀번호 찾기 실패: ${response.body}");
        return false; // 비밀번호를 찾지 못했음을 반환
      }
    } catch (error) {
      print("에러 발생: $error");
      return false; // 에러가 발생했음을 반환
    }
  }


  void saveDiet(String title, String date, String menu) async {
    var url = Uri.parse('$serverurl/saveDiet');
    var body = jsonEncode({'title': title, 'date': date, 'menu': menu});
    var headers = {'Content-Type': 'application/json'};

    try {
      var response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 201) {
        print('Diet saved successfully.');
      } else {
        print('Failed to save diet.');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
  Future<String> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString(('email')) ?? '';
    return email;
  }

}