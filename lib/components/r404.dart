import 'package:flutter/material.dart';
import 'package:get/get.dart';

class R404 extends StatelessWidget {
  const R404({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: Colors.white,
        child: Column(
          children: [
            Image.asset(
              'assets/images/content_failed.png',
              scale: 3.0,
            ),
            Text("404 未知的地址"),
            SizedBox(height: 20,),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    child: Text("返回"),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
