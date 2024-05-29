import 'package:flutter/material.dart';


class InfoPage extends StatelessWidget {
  final List<String> texts;

  InfoPage(this.texts);

  @override
  Widget build(BuildContext context) {
    String Text1 = texts.isNotEmpty ? texts.first : ""; // 첫 번째 텍스트 가져오기
    String Text2 = texts.length > 1 ? texts[1] : ""; // 세 번째 텍스트 가져오기
    String Text3 = texts.length > 2 ? texts[2] : ""; // 네 번째 텍스트 가져오기
    String Text4 = texts.length > 3 ? texts[3] : ""; // 다섯 번째 텍스트 가져오기
    String Text5 = texts.length > 4 ? texts[4] : ""; // 여섯 번째 텍스트 가져오기
    String Text6 = texts.length > 5 ? texts[5] : ""; // 일곱 번째 텍스트 가져오기
    String Text7 = texts.length > 5 ? texts[6] : ""; // 일곱 번째 텍스트 가져오기


    return Scaffold(
      appBar: AppBar(
        title: Text('식단 정보 및 수정'),
        backgroundColor: Colors.orange[300],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InfoText(
              text: Text1,
              onTap: () {
                // Text 1이 눌렸을 때 실행되는 동작
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Text 1 clicked')),
                );
              },
            ),
            SizedBox(height: 16.0),
            InfoText(
              text: Text2,
              onTap: () {
                // Text 2이 눌렸을 때 실행되는 동작
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Text 2 clicked')),
                );
              },
            ),
            SizedBox(height: 16.0),
            InfoText(
              text: Text3,
              onTap: () {
                // Text 3이 눌렸을 때 실행되는 동작
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Text 3 clicked')),
                );
              },
            ),
            SizedBox(height: 16.0),
            InfoText(
              text: Text4,
              onTap: () {
                // Text 3이 눌렸을 때 실행되는 동작
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Text 4 clicked')),
                );
              },
            ),
            SizedBox(height: 16.0),
            InfoText(
              text: Text5,
              onTap: () {
                // Text 3이 눌렸을 때 실행되는 동작
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Text 5 clicked')),
                );
              },
            ),
            SizedBox(height: 16.0),
            InfoText(
              text: Text6,
              onTap: () {
                // Text 3이 눌렸을 때 실행되는 동작
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Text 6 clicked')),
                );
              },
            ),
            SizedBox(height: 16.0),
            InfoText(
              text: Text7,
              onTap: () {
                // Text 3이 눌렸을 때 실행되는 동작
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Text 7 clicked')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class InfoText extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  InfoText({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18.0,
          color: Colors.blue,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}