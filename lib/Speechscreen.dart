import 'package:flutnew/colors.dart';
import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechScreen extends StatefulWidget {
  const SpeechScreen({Key? key}) : super(key: key);

  @override
  State<SpeechScreen> createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {

  SpeechToText speechToText= SpeechToText();

  var text = "Hold the button and start speaking";
  var isListening = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        endRadius: 75.0,
        animate: isListening,
        duration: const Duration(milliseconds: 2000),
        glowColor: Colors.blueGrey,
        repeat: true,
        repeatPauseDuration: const Duration(milliseconds: 100),
        showTwoGlows: true,
        child: GestureDetector(
          onTapDown: (details) async {
           if(!isListening){
             var available = await speechToText.initialize();
             if(available){
               setState(() {
                 isListening = true;
                 speechToText.listen(
                   onResult: (result){
                     setState(() {
                       text=result.recognizedWords;
                     });
                   }
                 );
               });
             }
           }
          },
          onTapUp: (details) {
            setState(() {
              isListening = false;
            });
            speechToText.stop();
          },
          child: CircleAvatar(
            backgroundColor: bgColor,
            radius: 35,
            child: Icon(isListening ? Icons.mic : Icons.mic_none, color: Colors.white),
          ),
        ),
      ),
      appBar: AppBar(
        leading: Icon(Icons.sort_rounded, color: Colors.white),
        centerTitle: true,
        backgroundColor: bgColor,
        elevation: 0,
        title: Text(
          "speech to text",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: textcolor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        physics: const BouncingScrollPhysics(),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.7,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          margin: const EdgeInsets.only(bottom: 150),
          child: Text(
            text,
            style: const TextStyle(
                fontSize: 24, color: Colors.black54, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
