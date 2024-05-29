
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:one_flutter_app/spring/service.dart';

import 'dietpage.dart';

class DietListPage extends StatefulWidget {
  @override
  _DietListPageState createState() => _DietListPageState();
}

class _DietListPageState extends State<DietListPage> {
  List<Map<String, dynamic>> diets = [];
  List<DateTime> selectedDates = [];
  List<dynamic> texts = [];
  Service service = Service();
  String serverurl = '';
  @override
  void initState() {
    super.initState();
    serverurl = service.getServerurl();
    _loadDiets();
  }

  Future<void> _loadDiets() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email') ?? ''; // 사용자의 이메일 가져오기
    var url = Uri.parse('$serverurl/api/diet/$email');

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        // UTF-8로 디코딩
        var jsonData = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          diets = List<Map<String, dynamic>>.from(jsonData);
        });
        // 각 diet의 selected_dates 출력
        for (var diet in diets) {
          var decodeedTexts = json.decode(diet['texts']);
          texts = decodeedTexts['monthlyMealPlan'];
          for(var day in texts){
            DateTime date = DateTime.parse(day['date']);
            selectedDates.add(date);
          }

          print('Selected Dates: $selectedDates');
        }
      } else {
        print('Failed to load diets data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('식단 리스트'),
      ),
      body: _buildList(),
    );
  }

  Widget _buildList() {
    if (diets.isEmpty) {
      return Center(
        child: Text('식단이 없습니다.'),
      );
    } else {
      return ListView.builder(
        itemCount: diets.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text('식단 제목: ${diets[index]['title']}'),
              onTap: () {

                // 해당 식단의 상세 페이지로 이동
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DietPage(
                        selectedDates: selectedDates,
                        jsonData: texts,
                      ),
                  ),
                );
              },
            ),
          );
        },
      );
    }
  }
}

