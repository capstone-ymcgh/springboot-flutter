import 'package:flutter/material.dart';
import 'package:one_flutter_app/loginpage.dart';
import 'calendarpage.dart';
import 'main.dart';
import 'infopage.dart';
import 'dart:convert'; // for json encoding and decoding
import 'package:http/http.dart' as http;
import 'package:one_flutter_app/spring/service.dart';

class DietPage extends StatefulWidget {
  final List<DateTime> selectedDates;
  final List<dynamic>? jsonData;

  DietPage({required this.selectedDates, this.jsonData});

  @override
  _DietPageState createState() => _DietPageState();
}

class _DietPageState extends State<DietPage> {
  bool _isListView = true; // 현재 보기가 일렬 보기인지 여부를 저장할 변수
  List<dynamic> recipeData = [];
  String originalJsonData = ''; // 추가: 원본 JSON 데이터를 저장할 변수
  Map<DateTime, List<String>> texts = {};
  List<DateTime> selectedDate = [];
  Service service = Service();
  String serverurl = '';
  final TextEditingController _titleController = TextEditingController();
  String yearMonthDay = '';
  String decodedData = '';

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    serverurl = service.getServerurl();
    if (widget.selectedDates.isNotEmpty) {
      DateTime firstDate = widget.selectedDates.first;
      yearMonthDay = "${firstDate.year}-${firstDate.month.toString().padLeft(2, '0')}-${firstDate.day.toString().padLeft(2, '0')}";

    }
    fetchMenuData(yearMonthDay, '0', 1);
  }

  // HTTP 요청을 보내고 JSON 데이터를 받아오는 함수
  Future<void> fetchMenuData(String date, String div, int serving) async {
    String url = '$serverurl/generate-meal-plan';
    final response = await http.get(
      Uri.parse('$url?month=$date&div=$div&servings=$serving'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8', // UTF-8 인코딩 사용 설정
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        final data = utf8.decode(response.bodyBytes); // UTF-8 디코딩 적용
        originalJsonData = data; // 추가: 원본 JSON 데이터를 저장
        var decodedData = json.decode(data);
        if(widget.jsonData != null){
          recipeData = widget.jsonData!;
        }else{
          recipeData = decodedData['monthlyMealPlan'];
        }
        parseRecipeData(recipeData);
      });
    } else {
      throw Exception('Failed to load menu data');
    }
  }

  // JSON 데이터를 파싱하여 Map<DateTime, List<String>> 형식으로 변환하는 함수
  void parseRecipeData(List<dynamic> recipeData) {
    texts.clear();
    for (var dayPlan in recipeData) {
      DateTime date = DateTime.parse(dayPlan['date']);
      String totalPrice = dayPlan['totalPrice'];
      List<String> meals = [];
      selectedDate.add(date);


      for (var meal in dayPlan['mealPlan']) {
        for (var dish in meal) {
          meals.add(dish);
        }
      }
      meals.add('가격: $totalPrice');
      texts[date] = meals;
    }
    print(texts); // 디버그용 출력


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('식단 페이지'),
        actions: [
          IconButton(
            icon: Icon(Icons.view_list),
            onPressed: () {
              setState(() {
                _isListView = true; // 일렬 보기로 설정
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () {
              setState(() {
                _isListView = false; // 달력 페이지 보기로 설정
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                _buildView(), // 선택된 보기에 따라 다른 위젯 빌드
                SizedBox(height: 20),
              ],
            ),
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: ElevatedButton(
              onPressed: _showSaveDialog,
              child: Text('저장'),
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                backgroundColor: Colors.orange, // 버튼의 배경색
                padding: EdgeInsets.all(20), // 버튼의 크기를 설정
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSaveDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('제목 입력'),
          content: TextField(
            controller: _titleController,
            decoration: InputDecoration(hintText: '제목을 입력하세요'),
          ),
          actions: [
            TextButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('저장'),
              onPressed: () async {
                String title = _titleController.text;
                if (title.isNotEmpty) {
                  await _saveData(title);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MyHomePage()),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveData(String title) async {
    String email = await service.getEmail();
    // HTTP POST 요청 보내기
    var url = Uri.parse('$serverurl/api/diet/save');
    var body = jsonEncode({
      'title': title,
      'texts': originalJsonData,
      'email' : email,
      'selectedDates' : selectedDate.toString()
    });
    var headers = {'Content-Type': 'application/json'};

    try {
      var response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 201) {
        print('Diet saved successfully.');
        print(selectedDate);
      } else {
        print('Failed to save diet.');
        print(selectedDate);

      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Widget _buildView() {
    if (_isListView) {
      return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: widget.selectedDates.length,
        itemBuilder: (BuildContext context, int index) {
          DateTime selectedDate = widget.selectedDates[index];
          List<String> selectedTexts = texts[selectedDate] ?? [];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => InfoPage(selectedTexts)),
              );
            },
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text(selectedDate.toString().substring(0, 10)),
                  subtitle: Text(selectedTexts.join(', ') ?? '식단 없음'),
                ),
                Divider(
                  color: Colors.black,
                ),
              ],
            ),
          );
        },
      );
    } else {
      DateTime firstDay = DateTime(widget.selectedDates[0].year, widget.selectedDates[0].month, 1);
      DateTime lastDay = DateTime(widget.selectedDates[0].year, widget.selectedDates[0].month + 1, 0);

      DateTime firstSunday = firstDay;
      while (firstSunday.weekday != 7) {
        firstSunday = firstSunday.subtract(Duration(days: 1));
      }

      return Container(
        height: 1500,
        child: GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: lastDay.difference(firstSunday).inDays + 1,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
            childAspectRatio: 0.3,
          ),
          itemBuilder: (context, index) {
            DateTime date = firstSunday.add(Duration(days: index));
            String dayOfWeek = _getDayOfWeekString(date.weekday);

            final boxTexts = texts[date] ?? [date.toString().substring(0, 10)];

            return InkWell(
              onTap: () {
                List<String> selectedTexts = texts[date] ?? [];
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InfoPage(selectedTexts)),
                );
              },
              child: Container(
                color: Colors.orange[200],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      dayOfWeek,
                      style: TextStyle(color: Colors.black, fontSize: 10),
                    ),
                    ...boxTexts.map((text) => Text(
                      text,
                      style: TextStyle(color: Colors.black, fontSize: 10),
                    )),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }
  }

  String _getDayOfWeekString(int weekday) {
    switch (weekday) {
      case 1:
        return '월';
      case 2:
        return '화';
      case 3:
        return '수';
      case 4:
        return '목';
      case 5:
        return '금';
      case 6:
        return '토';
      case 7:
        return '일';
      default:
        return '';
    }
  }
}
