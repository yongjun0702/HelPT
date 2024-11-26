import 'package:flutter/material.dart';
import 'package:helpt/config/color.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback func;  // <버튼이 클릭될 때 실행될 콜백 함수>
  final Color textColor;
  final Color backgroundColor;
  final int buttonCount;  // <버튼 개수: 1 or 2>
  final double width;
  final double height;
  const CustomButton({
    required this.width,
    required this.height,
    required this.text,
    required this.func,
    this.textColor = Colors.white,
    this.backgroundColor = HelPT.mainBlue,
    required this.buttonCount,
    super.key,});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: func,
        child: buttonCount == 1 ? Container(
          /// <단일 버튼>
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                    fontSize: 20,
                    color: textColor,
                    fontWeight: FontWeight.bold
                ),
              ),
            )
        ):
        Row(
          /// <두 개의 버튼>
          children: [
            Expanded(
              child: Container(
                  width: width,
                  height: height,
                  decoration: BoxDecoration(
                    color: HelPT.mainBlue,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Text(
                      "등록",
                      style: TextStyle(
                          fontSize: 20,
                          color: textColor,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  )
              ),
            ),
            SizedBox(width: 25),
            Expanded(
              child: Container(
                  width: width,
                  height: height,
                  decoration: BoxDecoration(
                    color: HelPT.subBlue,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Text(
                      "삭제",
                      style: TextStyle(
                          fontSize: 20,
                          color: HelPT.mainBlue,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  )
              ),
            ),
          ],
        )
    );
  }
}
