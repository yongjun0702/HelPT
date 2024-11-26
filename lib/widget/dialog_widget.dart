import 'package:helpt/config/color.dart';
import 'package:helpt/main.dart';
import 'package:flutter/material.dart';

Future<void> CustomDialog({
  bool barrierDismissible = false,
  required BuildContext context,
  required String title,
  required String dialogContent,
  required String? buttonText,
  required int buttonCount,
  required VoidCallback func,
}) {
  return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                backgroundColor: HelPT.background,
                surfaceTintColor: Colors.transparent,
                title: Center(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: ratio.height * 20,
                      fontWeight: FontWeight.bold,
                      color: HelPT.mainBlue
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                content: Container(
                  height: ratio.height * 30,
                  child: Center(
                      child: Text(dialogContent, style: TextStyle(fontSize: ratio.height * 17, color: HelPT.subBlue, fontWeight: FontWeight.bold))),
                ),
                actions: <Widget>[
                  /// <버튼이 2개일 때>
                  buttonCount == 2
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: HelPT.subBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              )),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            '취소',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: HelPT.tapBackgroud,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: ratio.width * 12),
                      Expanded(
                        child: TextButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: HelPT.mainBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              )),
                          onPressed: func,
                          child: Text(
                            '확인',
                            style: TextStyle(
                              fontSize: ratio.height * 16,
                              fontWeight: FontWeight.bold,
                              color: HelPT.tapBackgroud,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                      : Center(
                    child: Container(
                      width: ratio.width * 80,
                      child: TextButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: HelPT.mainBlue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            )),
                        onPressed: func,
                        child: Text(
                          buttonText!,
                          style: TextStyle(
                            fontSize: ratio.height * 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    side: BorderSide(color: HelPT.borderColor)),
              );
            });
      });
}
