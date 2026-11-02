import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OnDeviceAiService {
  static const platform = MethodChannel('com.example.mynote/gemini_nano');

  // دالة لإرسال البرومبت واستقبال الرد محلياً
  Future<String> generateResponse(String prompt) async {
    try {
      final String result = await platform.invokeMethod('runGeminiNano', {
        'prompt': prompt,
      });
      return result;
    } on PlatformException catch (e) {
      return "خطأ في تشغيل الذكاء الاصطناعي المحلي: '${e.message}'.";
    }
  }
}
class TestWidget extends StatefulWidget {
  const TestWidget({super.key});

  @override
  State<TestWidget> createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  OnDeviceAiService onDeviceAiService=OnDeviceAiService();
  String text ='' ;
  @override
  void initState() async{
    text= await onDeviceAiService.generateResponse("hi");
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(text,style: TextStyle(fontSize: 30),),
      ),
    );
  }
}
