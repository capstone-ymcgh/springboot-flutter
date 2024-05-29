import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';



class ProductOrderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('도매 상품 주문'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage(productName: '', productPrice: '',)
                ),
              );
              // 장바구니 아이콘으로 바꾸기
            },
            icon: Icon(Icons.card_travel),
            iconSize: 29,
          ),
          IconButton(
            icon: const Icon(Icons.search),
            iconSize: 28,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RecipeSearchPage(boxList1: [],)),
              );
              // 검색 아이콘 버튼을 눌렀을 때 실행할 동작
            },
          ),
        ],
      ),
      body: BoxGrid(),
    );
  }
}
class BoxItem1 {
  late String? title1; //글 제목
  late String? ingredient1; //레시피재료
  late String? content1; //글 작성내용
  late String? imagePath1; // 글 이미지
  final DateTime postDate1; //글 작성일자
  int likeCount1; // 좋아요 수 필드
  final int id; // 게시물을 식별하는 고유한 식별자
  List<String> comments; // New property to store comments

  //bool isSelected;

  BoxItem1({
    this.title1,
    this.ingredient1,
    this.content1,
    this.imagePath1,
    required this.postDate1,
    this.likeCount1 = 0, //기본값은 0으로 설정
    required this.id,

    List<String>? comments, // Nullable list of comments
  }) : comments = comments ?? []; // Initialize comments list

  // JSON 데이터를 BoxItem 객체로 변환하는 메서드
  factory BoxItem1.fromJson(Map<String, dynamic> json) {
    return BoxItem1(
      title1: json['title1'],
      ingredient1: json['ingredient1'],
      content1: json['content1'],
      imagePath1: json['imagePath1'],
      postDate1: DateTime.parse(json['postDate1']),

      id: 1, // JSON에서 DateTime으로 변환
    );
  }

  // BoxItem 객체를 JSON 데이터로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'title1': title1,
      'ingredient1': ingredient1,
      'content1': content1,
      'imagePath1': imagePath1,
      'postDate1': postDate1.toIso8601String(), // DateTime을 ISO 8601 문자열로 변환

    };
  }
}

class BoxListProvider1 extends ChangeNotifier {
  List<BoxItem1> _boxList1 = [];

  List<BoxItem1> get boxList1 => _boxList1;

  void setBoxList1(List<BoxItem1> newList) {
    _boxList1 = newList;
    notifyListeners(); // 상태가 변경됨을 Provider에 알림
  }
}

class BoxGrid extends StatefulWidget {
  @override
  _BoxGridState createState() => _BoxGridState();
}

class _BoxGridState extends State<BoxGrid> {
  List<BoxItem1> boxList1 = [];
  //여러 BoxItem 객체들을 담는 리스트인 boxList를 선언

  @override
  void initState() {
    super.initState();
    loadBoxList1();
  }

  Future<void> loadBoxList1() async {
    final prefs = await SharedPreferences.getInstance();
    final boxList1Json = prefs.getString('boxList1');
    if (boxList1Json != null) {
      setState(() {
        boxList1 = (json.decode(boxList1Json) as List<dynamic>)
            .map((e) => BoxItem1.fromJson(e))
            .toList();
        boxList1.sort((a, b) => b.postDate1.compareTo(a.postDate1)); // 역순으로 정렬
      });
    }
  }
  Future<void> saveBoxList1() async {
    final prefs = await SharedPreferences.getInstance();
    final boxList1Json = json.encode(boxList1.map((e) => e.toJson()).toList());
    await prefs.setString('boxList1', boxList1Json);
  }

  Future<void> _refreshData() async {
    // 여기서 필터링된 목록을 다시 계산하고 업데이트합니다.
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BoxListProvider1(), // Provider 생성
      child: _buildBoxGrid(), // BoxGrid를 감싸고 있는 위젯
    );
  }

  @override
  Widget _buildBoxGrid() {
    return Consumer<BoxListProvider1>(
        builder: (context, boxListProvider1, _){
          return RefreshIndicator(
            onRefresh: _refreshData,
            child: Stack(
              children: [
                SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: 10),
                          OutlinedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => FilterPage()),
                              );
                              // Handle sorting action
                            },
                            icon: Icon(Icons.expand_more),
                            label: Text('카테고리'),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                  width: 1.0, color: Color(0xff4ECB71)), // 테두리 색상 변경
                            ),
                          ),
                          SizedBox(width: 10),
                          OutlinedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => FilterPage()),
                              );
                              // Handle category action
                            },
                            icon: Icon(Icons.expand_more), // 아이콘 지우기
                            label: Text('채소류'),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                  width: 1.0, color: Color(0xff4ECB71)), // 테두리 색상 변경
                            ),
                          ),
                          SizedBox(width: 10),
                          OutlinedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => FilterPage()),
                              );
                              // Handle category action
                            },
                            icon: Icon(Icons.expand_more),
                            label: Text('디저트류'),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                  width: 1.0, color: Color(0xff4ECB71)), // 테두리 색상 변경
                            ),
                          ),
                        ],
                      ),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 3.0, // 박스 간의 상하 간격
                          crossAxisSpacing: 1.0, // 박스 간의 좌우 간격
                          childAspectRatio: 0.59,
                        ),
                        itemCount: boxList1.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailPage(
                                    boxItem1: boxList1[index],
                                    boxIndex: index, // Pass the box index
                                    onDelete: (deletedBox) {
                                      setState(() {
                                        boxList1.remove(deletedBox);
                                        saveBoxList1();
                                      });
                                      Navigator.pop(context); // 상세 페이지 닫기
                                      _refreshData();
                                    },
                                    onEdit: (editedBox, index) { // Add index parameter
                                      setState(() {
                                        boxList1[index] = editedBox;
                                        saveBoxList1();
                                      });
                                      Navigator.pop(context);
                                      _refreshData();
                                    }, boxList1: [],
                                  ),
                                ),
                              );
                              if (result != null && result is WritePageResult) {
                                setState(() {
                                  boxList1.insert(0, BoxItem1(
                                    title1: result.title1,
                                    ingredient1: result.ingredient1,
                                    content1: result.content1,
                                    imagePath1: result.imagePath1,
                                    postDate1: DateTime.now(),
                                    id: 1,
                                  ));
                                  boxList1.sort((a, b) => b.postDate1.compareTo(a.postDate1)); // 역순으로 정렬
                                });
                                saveBoxList1();
                              }
                            },
                            // 기본 페이지
                            child: Container(
                              margin: EdgeInsets.fromLTRB(3, 3, 3, 0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Stack(
                                    children: [
                                      AspectRatio(
                                        aspectRatio: 9.1 / 8.5,
                                        child: boxList1[index].imagePath1 != null
                                            ? Image.file(
                                          File(boxList1[index].imagePath1!),
                                          fit: BoxFit.cover,
                                        )
                                            : Image.asset(
                                          'assets/not_food_image.png',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(7, 0, 0, 148),
                                            child: Text(
                                              '종류',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 50.0),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(69.5, 137, 0, 0),
                                            child: IconButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => CartPage(
                                                    // 상품 정보를 전달
                                                    productName: boxList1[index].ingredient1 ?? '',
                                                    productPrice: boxList1[index].title1 ?? '',
                                                  )
                                                  ),
                                                );
                                                // 장바구니 아이콘으로 바꾸기
                                              },
                                              icon: Icon(Icons.card_travel),
                                              iconSize: 29,
                                              color: Color(0xff4ECB71),
                                              padding: EdgeInsets.zero,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          11.0, 8.0, 16.0, 0.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          //작성자(기본페이지)
                                          const SizedBox(height: 2.0),
                                          Row(
                                            children: [
                                              Padding(
                                                padding:EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                child: Image.asset(
                                                  'assets/profile_image.png',
                                                  width: 22.0,
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(4, 0, 0, 0),
                                                child:  Text(
                                                  '사업자명',
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 12),
                                                ),
                                              ),
                                            ],
                                          ),
                                          // 가격 표시
                                          const SizedBox(height: 5.0),
                                          Padding(
                                            padding:EdgeInsets.fromLTRB(2, 0, 0, 0),
                                            child:Text(
                                              '${boxList1[index].title1 ?? 'Title1'} 원',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          //글 제목(기본페이지)
                                          const SizedBox(height: 0.0),

                                          Padding(
                                            padding:EdgeInsets.fromLTRB(1, 0, 0, 0),
                                            child:Text(
                                              '${boxList1[index].ingredient1 ?? 'ingredient1'}',
                                              style: TextStyle(

                                                  fontSize: 18),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                                        child: Container(
                                          width: 199, // 버튼의 가로 크기
                                          height: 50, // 버튼의 세로 크기
                                          child: TextButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => OrderPage(cartItems: [],)),
                                              );
                                              // 주문하기 버튼이 눌렸을 때 수행할 작업 추가
                                            },
                                            child: Text(
                                              '주문하기',
                                              style: TextStyle(
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(327, 500, 0, 0),
                  child: GestureDetector(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WritePage(),
                        ),
                      );
                      if (result != null && result is WritePageResult) {
                        setState(() {
                          boxList1.add(BoxItem1(
                            title1: result.title1,
                            ingredient1: result.ingredient1,
                            content1: result.content1,
                            imagePath1: result.imagePath1,
                            postDate1: DateTime.now(),
                            id: 1,
                          ));
                          boxList1.sort((a,b) => b.postDate1.compareTo(a.postDate1));
                          // 글 작성 시에 새로운 박스가 추가될 때마다 리스트를 역순을 바로 반영.
                        });
                        saveBoxList1();
                      }
                    },
                    child: Image.asset(
                      'assets/recipe_button.png',
                      width: 60.0,
                      height: 60.0,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
    );
  }
}

//게시물 페이지 바꾸기
class DetailPage extends StatefulWidget {
  final BoxItem1 boxItem1;
  final Function(BoxItem1) onDelete;
  final Function(BoxItem1 editedBox, int index) onEdit;
  final int boxIndex;
  final List<BoxItem1> boxList1;

  DetailPage({required this.boxItem1, required this.onDelete, required this.onEdit, required this.boxIndex, required this.boxList1});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late TextEditingController titleController1;
  late TextEditingController ingredientController1;
  late TextEditingController contentController1;
  bool isEditing = false;
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    titleController1 = TextEditingController(text: widget.boxItem1.title1);
    ingredientController1 =
        TextEditingController(text: widget.boxItem1.ingredient1);
    contentController1 = TextEditingController(text: widget.boxItem1.content1);
  }

  @override
  void dispose() {
    titleController1.dispose();
    ingredientController1.dispose();
    contentController1.dispose();
    super.dispose();
  }

  void toggleEditing() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  void editedBox(int index) {
    widget.onEdit(BoxItem1(
      title1: titleController1.text,
      ingredient1: ingredientController1.text,
      content1: contentController1.text,
      imagePath1: widget.boxItem1.imagePath1,
      postDate1: widget.boxItem1.postDate1,
      id: 1,
    ), index);
  }

  @override
  Widget build(BuildContext context) {
    final postDateTime = widget.boxItem1.postDate1;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? '게시물 수정' : '게시물'),
        actions: [
          IconButton(
            onPressed: () async {
              if (isEditing) {
                setState(() {
                  editedBox(widget.boxIndex);
                  toggleEditing();
                });
              } else {
                toggleEditing();
              }
            },
            icon: Icon(isEditing ? Icons.check : Icons.edit),
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("글 삭제"),
                    content: Text("작성한 글을 삭제하시겠습니까?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("취소"),
                      ),
                      TextButton(
                        onPressed: () {
                          widget.onDelete(widget.boxItem1);
                          Navigator.of(context).pop();
                        },
                        child: Text("삭제"),
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(Icons.delete),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: isEditing
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (isEditing)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final pickedImage = await ImagePicker().getImage(
                              source: ImageSource.gallery);
                          if (pickedImage != null) {
                            setState(() {
                              widget.boxItem1.imagePath1 = pickedImage.path;
                            });
                          }
                        },
                        child: Container(
                          width: 100,
                          height: 100,
                          color: Color(0xFFD9D9D9),
                          margin: EdgeInsets.only(left: 0, bottom: 8),
                          child: Icon(
                            Icons.add,
                            color: Color(0xff4ECB71),
                            size: 40,
                          ),
                          alignment: Alignment.center,
                        ),
                      ),
                      SizedBox(width: 10),
                      if (widget.boxItem1.imagePath1 != null)
                        Image.file(
                          File(widget.boxItem1.imagePath1!),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                    ],
                  ),
                ),
              Text('가격'),
              TextField(
                controller: titleController1,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [ThousandsSeparatorInputFormatter()],
                decoration: InputDecoration(
                  hintText: '가격을 입력하세요',
                ),
                onChanged: (value) {
                  widget.boxItem1.title1 = value;
                },
              ),
              SizedBox(height: 8.0),
              Text('상품 이름'),
              TextField(
                controller: ingredientController1,
                decoration: InputDecoration(
                  hintText: '상품 이름을 입력하세요',
                ),
              ),
              SizedBox(height: 8.0),
              Text('상품 설명'),
              SizedBox(height: 8.0),
              Container(
                width: 240,
                height: 300,
                child: TextField(
                  maxLines: null,
                  expands: true,
                  keyboardType: TextInputType.multiline,
                  controller: contentController1,
                  decoration: InputDecoration(
                      filled: true, hintText: '상품 설명을 입력하세요.'),
                ),
              ),
            ],
          )
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: SizedBox(
                  width: 300,
                  height: 300,
                  child: widget.boxItem1.imagePath1 != null
                      ? Image.file(
                    File(widget.boxItem1.imagePath1!),
                    fit: BoxFit.cover,
                  )
                      : SizedBox(),
                ),
              ),
              SizedBox(height: 8),
              Divider(),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/profile_image.png',
                        width: 28.0,
                      ),
                      SizedBox(width: 8.0),
                      Text(
                        '사업자명',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),
              Divider(),
              Text(
                '${widget.boxItem1.title1 ?? 'Title1'} 원',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
              SizedBox(height: 3),
              Text(
                widget.boxItem1.ingredient1 ?? 'ingredient1',
                style: TextStyle(fontSize: 20.0),
              ),
              SizedBox(height: 4),
              Text(
                '종류',
                style: TextStyle(fontSize: 15.0,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 7),
              Divider(),
              Text('상품 설명'),
              SizedBox(height: 8),
              Text(
                widget.boxItem1.content1 ?? 'Content1',
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: !isEditing
          ? Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 16, 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Container(
                width: 300, // 버튼의 가로 크기
                height: 50, // 버튼의 세로 크기
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => OrderPage(cartItems: [],)),
                    );
                    // 주문하기 버튼이 눌렸을 때 수행할 작업 추가
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.grey[200], // 버튼의 배경색
                  ),
                  child: Text(
                    '주문하기',
                    style: TextStyle(
                      fontSize: 20, // 버튼 내 텍스트의 폰트 크기
                      //color: Colors.white, // 버튼 내 텍스트의 색상
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 15), // 아이콘 버튼과 주문하기 버튼 사이 간격 조정
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CartPage(
                      // 상품 정보를 전달합니다.
                      productName: widget.boxItem1.ingredient1 ?? '',
                      productPrice: widget.boxItem1.title1 ?? '',
                    ),
                    ),
                  );
                  // 장바구니 아이콘으로 바꾸기
                },
                icon: Icon(Icons.card_travel),
                iconSize: 29,
                color: Color(0xff4ECB71),
                padding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      )
          : null,
      floatingActionButton: isEditing
          ? FloatingActionButton(
        onPressed: () {
          toggleEditing();
        },
        child: Icon(Icons.close),
      )
          : null,
    );
  }
}

class WritePageResult {
  late final String title1; //글 제목
  late final String ingredient1; //레시피 재료
  late final String content1; //작성할 내용
  late final String? imagePath1; //이미지 로드
  final DateTime postDate1; // 추가된 postDate 필드

  WritePageResult({required this.title1,required this.ingredient1, required this.content1, this.imagePath1, required this.postDate1});
}

//글작성페이지 바꾸기
class WritePage extends StatefulWidget {
  @override
  _WritePageState createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> {
  File? selectedImage; // 이미지를 저장할 변수 선언
  String _selectedCategory = '';

  TextEditingController titleController1 = TextEditingController();
  TextEditingController contentController1 = TextEditingController();
  TextEditingController ingredientController1 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('상품정보 작성'),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column( // 글 작성하기 이미지
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      final pickedImage = await ImagePicker().getImage(source: ImageSource.gallery);
                      if (pickedImage != null) {
                        // 이미지 선택 시 선택한 이미지를 저장하고 UI를 업데이트하여 이미지를 보여줌
                        setState(() {
                          selectedImage = File(pickedImage.path);
                        });
                      }
                    },
                    child: Container(
                      width: 100,
                      height: 100, // 네모난 박스의 높이
                      color: Color(0xFFD9D9D9), // 박스의 색상
                      margin: EdgeInsets.only(left:0, bottom: 0, right: 0), // 박스와 제목 사이의 간격
                      child: Icon(
                        Icons.add,
                        color: Color(0xff4ECB71),
                        size: 40,
                      ),
                      alignment: Alignment.center,
                    ),
                  ),

                  SizedBox(width: 10),

                  // 선택한 이미지가 있을 경우 보여줌
                  if (selectedImage != null)
                    Image.file(
                      selectedImage!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                ],
              ),

              // 글 작성하기 내용
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 10.0),
                  TextField(
                    controller: titleController1,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [ThousandsSeparatorInputFormatter()],
                    decoration: InputDecoration(
                      hintText: '가격을 입력하세요',
                    ),
                  ),
                  SizedBox(height: 30.0),
                  Text(
                    "카테고리 설정",
                    style: TextStyle(
                        fontSize: 18
                    ),
                  ),

                  SizedBox(height: 10,),
                  //카테고리 필터 메뉴 넣기
                  Row(
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          setState(() {
                            if (_selectedCategory == '채소류/과일') {
                              _selectedCategory = ''; // 선택 취소
                            } else {
                              _selectedCategory = '채소류/과일'; // '학생' 선택
                            }
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            width: 1.0,
                            color: _selectedCategory == '채소류/과일' ? Color(0xff4ECB71) : Colors.grey,
                          ),
                          backgroundColor: _selectedCategory == '채소류/과일' ? Color(0xff4ECB71) : Colors.transparent,
                          padding: EdgeInsets.symmetric(horizontal: 40.0), // 좌우 여백 조절
                        ),
                        child: Text(
                          '채소류/과일',
                          style: TextStyle(
                            color: _selectedCategory == '채소류/과일' ? Colors.white : Color(0xff4ECB71), // 글자색 변경
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      OutlinedButton(
                        onPressed: () {
                          setState(() {
                            if (_selectedCategory == '육류/해산물') {
                              _selectedCategory = ''; // 선택 취소
                            } else {
                              _selectedCategory = '육류/해산물'; // '성인' 선택
                            }
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            width: 1.0,
                            color: _selectedCategory == '육류/해산물' ? Color(0xff4ECB71) : Colors.grey,
                          ),
                          backgroundColor: _selectedCategory == '육류/해산물' ? Color(0xff4ECB71) : Colors.transparent,
                          padding: EdgeInsets.symmetric(horizontal: 40.0), // 좌우 여백 조절
                        ),
                        child: Text(
                          '육류/해산물',
                          style: TextStyle(
                            color: _selectedCategory == '육류/해산물' ? Colors.white : Color(0xff4ECB71), // 글자색 변경
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20,),
                  TextField(
                    controller: ingredientController1,
                    decoration: InputDecoration(
                      hintText: '상품 이름을 입력하세요',
                    ),
                  ),

                  SizedBox(height: 30,),
                  Container(
                    width: 240,
                    height: 220,
                    child: TextField(
                      maxLines: null,
                      expands: true,
                      keyboardType: TextInputType.multiline,
                      controller: contentController1,
                      decoration: InputDecoration(filled: true, hintText: '상품 설명을 입력하세요.'),
                    ),
                  ),

                  SizedBox(height: 8.0),
                  ElevatedButton(
                    onPressed: () {
                      // 작성 완료 버튼이 눌렸을 때만 글이 작성되도록 수정
                      if (selectedImage == null) {
                        // 이미지를 선택하지 않았을 때는 사용자에게 알림
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title:
                              Text(
                                '업로드 실패',
                                style: TextStyle(
                                  fontSize: 20, //폰트 크기 조절
                                ),
                              ),
                              content: Text('이미지를 선택해주세요.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('확인'),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        // 이미지를 선택한 경우 작성을 완료함
                        final postDate1 = DateTime.now();
                        Navigator.pop(
                          context,
                          WritePageResult(
                            title1: titleController1.text,
                            ingredient1: ingredientController1.text,
                            content1: contentController1.text,
                            imagePath1: selectedImage?.path, // 선택한 이미지의 경로를 전달
                            postDate1: postDate1,
                          ),
                        );
                      }
                    },
                    child: Text('작성 완료'),
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

//필터 페이지 바꾸기
class FilterPage extends StatefulWidget{
  @override
  _FilterPageState createState() => _FilterPageState();
}
class _FilterPageState extends State<FilterPage> {
  String _selectedSort = '좋아요순'; // 초기값을 '좋아요순'으로 설정
  String _selectedCategory = ''; // 선택된 카테고리(학생/성인)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('필터'),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(30, 20, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "정렬",
                    style: TextStyle(fontSize: 23),
                  ),
                  SizedBox(height: 10),
                  RadioListTile(
                    title: Text('좋아요순'),
                    value: '좋아요순',
                    groupValue: _selectedSort,
                    onChanged: (value) {
                      setState(() {
                        _selectedSort = value!;
                      });
                    },
                  ),
                  RadioListTile(
                    title: Text('최신순'),
                    value: '최신순',
                    groupValue: _selectedSort,
                    onChanged: (value) {
                      setState(() {
                        _selectedSort = value!;
                      });
                    },
                  ),
                  SizedBox(height: 26),
                  Text(
                    "연령대",
                    style: TextStyle(fontSize: 23),
                  ),

                  SizedBox(height: 20),
                  Row(
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          setState(() {
                            if (_selectedCategory == '채소류/과일') {
                              _selectedCategory = ''; // 선택 취소
                            } else {
                              _selectedCategory = '채소류/과일'; // '학생' 선택
                            }
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            width: 1.0,
                            color: _selectedCategory == '채소류/과일' ? Color(0xff4ECB71) : Colors.grey,
                          ),
                          backgroundColor: _selectedCategory == '채소류/과일' ? Color(0xff4ECB71) : Colors.transparent,
                          padding: EdgeInsets.symmetric(horizontal: 40.0), // 좌우 여백 조절
                        ),
                        child: Text(
                          '채소류/과일',
                          style: TextStyle(
                            color: _selectedCategory == '채소류/과일' ? Colors.white : Color(0xff4ECB71), // 글자색 변경
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      OutlinedButton(
                        onPressed: () {
                          setState(() {
                            if (_selectedCategory == '육류/해산물') {
                              _selectedCategory = ''; // 선택 취소
                            } else {
                              _selectedCategory = '육류/해산물'; // '성인' 선택
                            }
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            width: 1.0,
                            color: _selectedCategory == '육류/해산물' ? Color(0xff4ECB71) : Colors.grey,
                          ),
                          backgroundColor: _selectedCategory == '육류/해산물' ? Color(0xff4ECB71) : Colors.transparent,
                          padding: EdgeInsets.symmetric(horizontal: 40.0), // 좌우 여백 조절
                        ),
                        child: Text(
                          '육류/해산물',
                          style: TextStyle(
                            color: _selectedCategory == '육류/해산물' ? Colors.white : Color(0xff4ECB71), // 글자색 변경
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 28), // 여백 크기 조절
                  child: TextButton(
                    onPressed: () {
                      // 완료 버튼 동작
                    },
                    child: Text(
                      "완료",
                      style: TextStyle(fontSize: 18),
                    ),
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(Size(120, 70)), // 최소 크기 설정
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 28), // 여백 크기 조절
                  child: TextButton(
                    onPressed: () {
                      // 취소 버튼 동작
                    },
                    child: Text(
                      "취소",
                      style: TextStyle(fontSize: 18),
                    ),
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(Size(120, 70)), // 최소 크기 설정
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// 도매 페이지 검색창으로 바꾸기
class RecipeSearchPage extends StatefulWidget {
  final List<BoxItem1> boxList1; // 전체 박스 목록

  RecipeSearchPage({required this.boxList1});

  @override
  _RecipeSearchPageState createState() => _RecipeSearchPageState();
}

class _RecipeSearchPageState extends State<RecipeSearchPage> {
  List<BoxItem1> boxList1 = [];
  List<BoxItem1> filteredBoxList1 = []; // 필터링된 목록을 저장할 변수

  @override
  void initState() {
    super.initState();
    loadBoxList1();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadBoxList1(); // 페이지가 화면에 나타날 때마다 데이터 업데이트
  }

  Future<void> loadBoxList1() async {
    final prefs = await SharedPreferences.getInstance();
    final boxList1Json = prefs.getString('boxList1');
    if (boxList1Json != null) {
      setState(() {
        boxList1 = (json.decode(boxList1Json) as List<dynamic>)
            .map((e) => BoxItem1.fromJson(e))
            .toList();
        filteredBoxList1 = List.from(boxList1); // 초기에는 전체 목록을 필터된 목록으로 설정
      });
    }
  }

  Future<void> saveBoxList1() async {
    final prefs = await SharedPreferences.getInstance();
    final boxList1Json = json.encode(boxList1.map((e) => e.toJson()).toList());
    await prefs.setString('boxList1', boxList1Json);
  }

  String _searchQuery = ''; // 검색어 상태 추가

  // 검색어를 기반으로 목록을 필터링하는 메서드
  void filterBoxList1(String query) {
    setState(() {
      _searchQuery = query; // 검색어 상태 업데이트
      if (query.isEmpty) {
        // 검색어가 없으면 전체 목록을 필터링된 목록으로 설정
        filteredBoxList1 = List.from(boxList1);
      } else {
        // 검색어가 포함된 박스만 필터링하여 보여줍니다.
        filteredBoxList1 = boxList1.where((box) =>
            box.ingredient1!.toLowerCase().contains(query.toLowerCase())).toList();
      }
    });
  }
  Future<void> _refreshData() async {
    // 여기서 필터링된 목록을 다시 계산하고 업데이트
    filterBoxList1(_searchQuery);
    // setState를 호출하여 화면을 다시 그리도록 함
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('상품 검색'),
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: _refreshData,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  // 검색창 추가
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      onChanged: (value) {
                        // 검색어가 변경될 때마다 필터링된 결과 업데이트
                        filterBoxList1(value);
                      },
                      decoration: InputDecoration(
                        hintText: '검색어를 입력하세요',
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 20),
                    ],
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 3.0, // 박스 간의 상하 간격
                      crossAxisSpacing: 1.0, // 박스 간의 좌우 간격
                      childAspectRatio: 0.59,
                    ),
                    itemCount: filteredBoxList1.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailPage(
                                boxItem1:filteredBoxList1[index],
                                boxIndex: index,
                                onDelete: (deletedBox) {
                                  setState(() {
                                    boxList1.remove(deletedBox);
                                    saveBoxList1(); // 삭제 후 상태를 저장
                                    filteredBoxList1 = List.from(boxList1); // 수정된 boxList로 filteredBoxList 업데이트
                                  });
                                  Navigator.pop(context); // 상세 페이지 닫기
                                  _refreshData();
                                },
                                onEdit: (editedBox, index) {
                                  setState(() {
                                    boxList1[index] = editedBox;
                                    saveBoxList1();
                                    filteredBoxList1 = List.from(boxList1); // 수정된 boxList로 filteredBoxList 업데이트
                                  });
                                  Navigator.pop(context);
                                  _refreshData();
                                }, boxList1: [],
                              ),
                            ),
                          );
                          if (result != null && result is WritePageResult) {
                            setState(() {
                              boxList1.add(BoxItem1(
                                title1: result.title1,
                                ingredient1: result.ingredient1,
                                content1: result.content1,
                                imagePath1: result.imagePath1,
                                postDate1: DateTime.now(),
                                id:1,
                              ));
                            });
                            saveBoxList1();
                          }
                        },

                        child: Container(
                          margin: EdgeInsets.fromLTRB(3, 3, 3, 0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Stack(
                                children: [
                                  AspectRatio(
                                    aspectRatio: 9.1 / 8.5,
                                    child: filteredBoxList1[index].imagePath1 != null
                                        ? Image.file(
                                      File(filteredBoxList1[index].imagePath1!),
                                      fit: BoxFit.cover,
                                    )
                                        : Image.asset(
                                      'assets/not_food_image.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(10.5, 0, 0, 148),
                                        child: Text(
                                          '종류',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 50.0),
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(69.5, 137, 0, 0),
                                        child: IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => CartPage(
                                                // 상품 정보를 전달합니다.
                                                productName: boxList1[index].ingredient1 ?? '',
                                                productPrice: boxList1[index].title1 ?? '',
                                              ),
                                              ),
                                            );
                                            // 장바구니 아이콘으로 바꾸기
                                          },
                                          icon: Icon(Icons.card_travel),
                                          iconSize: 29,
                                          color: Color(0xff4ECB71),
                                          padding: EdgeInsets.zero,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      11.0, 8.0, 16.0, 0.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      //작성자(기본페이지)
                                      const SizedBox(height: 2.0),
                                      Row(
                                        children: [
                                          Padding(
                                            padding:EdgeInsets.fromLTRB(0, 0, 0, 0),
                                            child: Image.asset(
                                              'assets/profile_image.png',
                                              width: 22.0,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(4, 0, 0, 0),
                                            child:  Text(
                                              '사업자명',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12),
                                            ),
                                          ),
                                        ],
                                      ),
                                      // 가격 표시
                                      const SizedBox(height: 5.0),
                                      Padding(
                                        padding:EdgeInsets.fromLTRB(2, 0, 0, 0),
                                        child:Text(
                                          '${filteredBoxList1[index].title1 ?? 'Title1'} 원',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      //글 제목(기본페이지)
                                      const SizedBox(height: 0.0),

                                      Padding(
                                        padding:EdgeInsets.fromLTRB(2, 0, 0, 0),
                                        child:Text(
                                          '${filteredBoxList1[index].ingredient1 ?? 'ingredient1'}',
                                          style: TextStyle(
                                              fontSize: 18),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                                    child: Container(
                                      width: 199, // 버튼의 가로 크기
                                      height: 50, // 버튼의 세로 크기
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => OrderPage(cartItems: [],)),
                                          );
                                          // 주문하기 버튼이 눌렸을 때 수행할 작업 추가
                                        },
                                        child: Text(
                                          '주문하기',
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//주문하기 페이지
class OrderPage extends StatefulWidget {
  final List<CartItem> cartItems; // 선택한 목록을 전달받음

  OrderPage({required this.cartItems});

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  String? shippingAddress;
  String? paymentMethod;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('주문하기'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '배송지',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(shippingAddress ?? '배송지를 선택해주세요'),
                ),
                TextButton(
                  onPressed: () {
                    // 배송지 선택 페이지를 열고 주소를 가져와 shippingAddress에 저장
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShippingAddressPage(
                          onAddressSelected: (name, phoneNumber, address) {
                            setState(() {
                              shippingAddress = '$name\n$phoneNumber\n$address';
                            });
                          },
                        ),
                      ),
                    );
                  },
                  child: Text('배송지 선택'),
                ),
              ],
            ),
            SizedBox(height: 50),
            Text(
              '결제수단',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Column(
              children: [
                RadioListTile(
                  title: Text('신용/체크카드'),
                  value: '신용/체크카드',
                  groupValue: paymentMethod,
                  onChanged: (String? value) {
                    setState(() {
                      paymentMethod = value;
                    });
                  },
                ),
                RadioListTile(
                  title: Text('계좌이체/무통장입금'),
                  value: '계좌이체/무통장입금',
                  groupValue: paymentMethod,
                  onChanged: (String? value) {
                    setState(() {
                      paymentMethod = value;
                    });
                  },
                ),
                RadioListTile(
                  title: Text('휴대폰결제'),
                  value: '휴대폰결제',
                  groupValue: paymentMethod,
                  onChanged: (String? value) {
                    setState(() {
                      paymentMethod = value;
                    });
                  },
                ),
              ],
            ),
            Spacer(),

            // 결제하기 버튼
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('결제 확인'),
                        content: Text('정말로 결제하시겠습니까?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(false); // 취소 버튼을 누른 경우, false 반환
                            },
                            child: Text('취소'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(true); // 확인 버튼을 누른 경우, true 반환
                            },
                            child: Text('확인'),
                          ),
                        ],
                      );
                    },
                  ).then((confirmed) {
                    if (confirmed != null && confirmed) {
                      // 확인 버튼을 누른 경우, 결제가 완료되었음을 알림
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('결제 완료'),
                            content: Text('결제가 완료되었습니다.'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(true); // 결제 완료를 알리면서 주문 페이지를 닫음
                                  // 주문 페이지(OrderPage)에서 결제가 완료된 항목들을 반환합니다.
                                  Navigator.of(context).pop(widget.cartItems.where((item) => item.isSelected).toList());
                                },
                                child: Text('확인'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  });
                },
                child: Text('결제하기'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//장바구니 페이지 만들기
class CartItem {
  final String name;
  final int price;
  bool isSelected;

  CartItem({required this.name, required this.price, this.isSelected = false});
}

class CartPage extends StatefulWidget {
  final String productName;
  final String productPrice;

  CartPage({required this.productName, required this.productPrice});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartItem> cartItems = [];
  List<BoxItem1> boxList1 = [];
  bool isAllSelected = false;

  @override
  void initState() {
    super.initState();
    _loadCartItems();
    _addToCart(widget.productName, widget.productPrice); // 새로운 데이터 추가


  }


  // 장바구니 항목을 로드합니다.
  void _loadCartItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cartItemsJson = prefs.getString('cartItems');
    if (cartItemsJson != null) {
      List<dynamic> decodedItems = json.decode(cartItemsJson);
      List<CartItem> loadedItems = decodedItems
          .map((item) => CartItem(
        name: item['name'],
        price: item['price'],
        isSelected: item['isSelected'],
      ))
          .toList();
      setState(() {
        cartItems.addAll(loadedItems);
      });
    }
  }


  // 장바구니 항목을 저장합니다.
  void _saveCartItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> encodedItems = cartItems
        .map((item) => {
      'name': item.name,
      'price': item.price,
      'isSelected': item.isSelected,
    })
        .toList();
    String cartItemsJson = json.encode(encodedItems);
    prefs.setString('cartItems', cartItemsJson);
  }

  // 장바구니에 항목을 추가합니다.
  void _addToCart(String? productName, String? productPrice) {
    if (productName != null && productPrice != null) {
      int? price = int.tryParse(productPrice.replaceAll(',', ''));
      if (price != null) {
        setState(() {
          cartItems.add(CartItem(name: productName, price: price));
          _saveCartItems();
        });
      } else {
        print('Failed to parse price');
      }
    } else {
      print('Product name or price is null');
    }
  }


  @override
  Widget build(BuildContext context) {
    int total = 0;

    //상품 가격 합계
    cartItems.forEach((item) {
      if (item.isSelected) {
        total += item.price;
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('장바구니'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Checkbox(
                    value: cartItems[index].isSelected,
                    onChanged: (bool? value) {
                      setState(() {
                        cartItems[index].isSelected = value ?? false;
                      });
                    },
                  ),
                  title: Text(cartItems[index].name),
                  subtitle: Text('${NumberFormat.currency(locale: 'ko_KR', symbol: '').format(cartItems[index].price)} 원'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        cartItems.removeAt(index);
                        _saveCartItems();
                      });
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: isAllSelected,
                      onChanged: (bool? value) {
                        setState(() {
                          isAllSelected = value ?? false;
                          cartItems.forEach((item) {
                            item.isSelected = isAllSelected;
                          });
                        });
                      },
                    ),
                    Text('전체 선택'),
                  ],
                ),
                Text(
                  '합계: ${NumberFormat.currency(locale: 'ko_KR', symbol: '').format(total)} 원',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child:ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderPage(cartItems: cartItems), // 선택한 목록을 주문하기 페이지로 전달
                    ),
                  ).then((completedItems) {
                    if (completedItems != null && completedItems.isNotEmpty) {
                      // 결제가 완료된 항목들을 장바구니에서 제거
                      setState(() {
                        cartItems.removeWhere((item) => completedItems.contains(item));
                        _saveCartItems(); // 변경된 장바구니 목록을 저장
                      });
                    }
                  });
                },
                child: Text('결제하기'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//배송지 선택 페이지
class ShippingAddressPage extends StatefulWidget {
  final Function(String, String, String) onAddressSelected;

  ShippingAddressPage({required this.onAddressSelected});

  @override
  _ShippingAddressPageState createState() => _ShippingAddressPageState();
}

class _ShippingAddressPageState extends State<ShippingAddressPage> {
  late TextEditingController _nameController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _addressController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('배송지 선택'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '이름',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: '이름을 입력해주세요',
              ),
            ),
            SizedBox(height: 20),
            Text(
              '전화번호',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _phoneNumberController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: '전화번호를 입력해주세요',
              ),
              onChanged: (String value) {
                if (value.length == 3 || value.length == 8) {
                  // 번호 입력에 따라 '-'를 자동으로 추가
                  _phoneNumberController.text = '$value-';
                  _phoneNumberController.selection = TextSelection.fromPosition(
                    TextPosition(offset: _phoneNumberController.text.length),
                  );
                }
              },
            ),
            SizedBox(height: 20),
            Text(
              '주소',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                hintText: '주소를 입력해주세요',
              ),
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // 입력된 정보를 가져와서 부모 위젯으로 전달하고 페이지 닫기
                  String name = _nameController.text;
                  String phoneNumber = _phoneNumberController.text;
                  String address = _addressController.text;
                  widget.onAddressSelected(name, phoneNumber, address);
                  Navigator.pop(context);
                },
                child: Text('주소 선택 완료'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 입력시 쉼표 자동 추가
class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    final double value = double.parse(newValue.text.replaceAll(',', ''));
    final String newText = NumberFormat('#,###').format(value);

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}