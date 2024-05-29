import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'dietpage.dart';


class InputPage extends StatelessWidget {
  final TextEditingController _controller1 = TextEditingController(text: DateTime.now().year.toString());
  final TextEditingController _controller2 = TextEditingController(text: DateTime.now().month.toString());

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: TextField(
            controller: _controller1,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: '년도 입력',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: TextField(
            controller: _controller2,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: '달 입력',
              border: OutlineInputBorder(),
            ),
          ),
        ),

        GestureDetector(
          onTap: () {
            // 버튼을 눌렀을 때 실행되는 동작
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CalendarPage(
                  number1: int.tryParse(_controller1.text),
                  number2: int.tryParse(_controller2.text),
                ),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10.0),
            ),
            padding:
            EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Text(
              '다음',
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
          ),
        ),
      ],
    );
  }
}


class CalendarPage extends StatefulWidget {
  final int? number1;
  final int? number2;

  CalendarPage({required this.number1, required this.number2});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late List<DateTime> _selectedDates;

  @override
  void initState() {
    super.initState();
    //_selectedDates = _getAllWeekdays(DateTime(DateTime.now().year, DateTime.now().month, 1), 31); // 현재 달의 1일부터 30일 동안의 모든 주중 날짜 선택
    // number1과 number2를 사용하여 _selectedDates를 변경
    if (widget.number1 != null && widget.number2 != null) {
      if(widget.number2 == 1 || widget.number2 == 3 || widget.number2 == 5 || widget.number2 == 7 || widget.number2 == 8 || widget.number2 == 10 || widget.number2 == 12) {
        _selectedDates = _getAllWeekdays(DateTime(widget.number1!, widget.number2!), 31);
      }
      else if(widget.number2 == 2){
        if(widget.number1!%4==0){
          _selectedDates = _getAllWeekdays(DateTime(widget.number1!, widget.number2!), 29);
        }
        else {
          _selectedDates = _getAllWeekdays(DateTime(widget.number1!, widget.number2!), 28);
        }
      }
      else{
        _selectedDates = _getAllWeekdays(DateTime(widget.number1!, widget.number2!), 30);
      }
    }
  }


  // 시작 날짜부터 지정된 기간 동안의 모든 주중 날짜를 반환하는 함수
  List<DateTime> _getAllWeekdays(DateTime startDate, int days) {
    List<DateTime> weekdays = [];
    for (int i = 0; i < days; i++) {
      DateTime currentDate = startDate.add(Duration(days: i));
      if (currentDate.weekday != DateTime.saturday && currentDate.weekday != DateTime.sunday) {
        weekdays.add(currentDate);
      }
    }
    return weekdays;
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      _selectedDates = args.value.cast<DateTime>();
      _selectedDates.sort();
      print(_selectedDates);
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('날짜 선택'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SfDateRangePicker(
              allowViewNavigation: false,
              onSelectionChanged: _onSelectionChanged,
              selectionMode: DateRangePickerSelectionMode.multiple,
              initialSelectedDates: _selectedDates,
              initialDisplayDate: DateTime(widget.number1!, widget.number2!),
              headerStyle: DateRangePickerHeaderStyle(
                textAlign: TextAlign.center,
              ),
              //todayHighlightColor: Colors.blue,
              selectionColor: Colors.orange[300],
              startRangeSelectionColor: Colors.blue.withOpacity(0.1),
              endRangeSelectionColor: Colors.blue.withOpacity(0.1),
              monthViewSettings: DateRangePickerMonthViewSettings(
                firstDayOfWeek: 7,
                weekendDays: [7, 6],
                //specialDates:[DateTime(2024, 05, 06),DateTime(2024, 05, 15)],
                dayFormat: 'EEE',
              ),
              monthCellStyle: DateRangePickerMonthCellStyle(
                weekendTextStyle: TextStyle(color: Colors.red),
                //specialDatesTextStyle: TextStyle(color: Colors.red),
              ),
            ),
          ),
          SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              // 버튼을 눌렀을 때 실행되는 동작
              print('확인 버튼이 눌렸습니다.');
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DietPage(selectedDates:_selectedDates)),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Text(
                '식단 만들기',
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}