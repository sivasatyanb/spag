import 'package:flutter/material.dart';
import '../pages/one.dart';
import '../pages/two.dart';
import '../pages/three.dart';

class Tutorial extends StatefulWidget {
  const Tutorial({super.key});
  @override
  State<Tutorial> createState() => TutorialState();
}

class TutorialState extends State<Tutorial> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            children: const [
              One(),
              Two(),
              Three(),
            ],
          ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: _currentIndex == index
                        ? const Color(0xff000054)
                        : Colors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
