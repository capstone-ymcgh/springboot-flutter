import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'RecipeSharedPage.dart';  // BoxListProvider가 정의된 파일을 임포트

class AppProvider extends StatelessWidget {
  final Widget child;

  AppProvider({required this.child});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final provider = BoxListProvider();
        provider.loadBoxList(); // 데이터 로드
        return provider;
      },
      child: child,
    );
  }
}
