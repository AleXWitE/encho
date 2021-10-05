import 'dart:math';

import 'package:encho/commons/models/words_model.dart';
import 'package:encho/commons/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'listening_screen.dart';

class SpeakingScreen extends StatefulWidget {
  @override
  _SpeakingScreenState createState() => _SpeakingScreenState();
}

class _SpeakingScreenState extends State<SpeakingScreen> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences prefs;

  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  bool cutRecord = true;
  String _lastWords = "";
  var locales;
  var selectedLocales;

  int id = 0;
  int _i = 0;

  bool _speakerStatus = false;
  bool _randomPlay = false;
  int repeatCircle = 0;
  int countRepeat;
  int delayRepeat;
  String language;
  double volume;
  double pitch;
  double rate;

  String _word1;
  String _word2;
  String _startWelcome;
  String _lang1;
  String _lang2;

  FlutterTts flutterTts;
  TtsState ttsState = TtsState.stopped;

  String learningWord;
  String _checkWord;
  int _check = 0;
  int _timerSec = 999;

  _getPrefs() async {
    prefs = await _prefs;
    volume = (prefs.getDouble("VOLUME") ?? 0.5);
    pitch = (prefs.getDouble("PITCH") ?? 1.0);
    rate = (prefs.getDouble("RATE") ?? 0.5);
    language = (prefs.getString("CORRECT_LANGUAGE") ?? "ru");
    countRepeat = (prefs.getInt("COUNT_REPEAT") ?? 1);
    delayRepeat = (prefs.getInt("DELAY_REPEAT") ?? 1);
  }

  _getRepeatAndRandom() async {
    prefs = await _prefs;
    setState(() {
      repeatCircle = (prefs.getInt("REPEAT_CIRCLE") ?? 0);
      _randomPlay = (prefs.getBool("RANDOM_PLAY") ?? false);
    });
  }

  _listen() async {
    setState(() => _speakerStatus = true);
    switch (language) {
      case "en":
        setState(() => learningWord = wordList[id].ruWord);
        break;
      case "ru":
        setState(() => learningWord = wordList[id].enWord);
        break;
    }

    await _speechToText.listen(onResult: _onSpeechResult, localeId: language);
    await Future.delayed(Duration(seconds: 3));

    if (_lastWords == learningWord.toLowerCase()) {
      _checkWord = "correct";
      _check++;
    } else
      _checkWord = "wrong";

    setState(() => _lastWords = "");

    await _speechToText.stop();
  }

  _stop() async {
    await _speechToText.stop();
    setState(() {
      _speakerStatus = false;
      _timerSec = 999;
    });
    if (_check == countRepeat)
      setState(() {
        id++;
        _lastWords = "";
      });
  }

  _checkStop() {
    if (_check == countRepeat)
      setState(() {
        _speakerStatus = false;
        _lastWords = "";
      });
  }

  _onSpeechResult(SpeechRecognitionResult result) {
    setState(() => _lastWords = result.recognizedWords.toLowerCase());
  }

  _randomNextWord() {
    setState(() => id = Random().nextInt(wordList.length - 2));
  }

  _savePrefs() async {
    prefs = await _prefs;
    await prefs.setInt("REPEAT_CIRCLE", repeatCircle);
    await prefs.setBool("RANDOM_PLAY", _randomPlay);
  }

  void initState() {
    super.initState();
    _initSpeech();
    _initTts();
    _getPrefs();
    _getRepeatAndRandom();
  }

  void dispose() {
    super.dispose();
    _savePrefs();
  }

  _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  _initTts() {
    flutterTts = FlutterTts();

    flutterTts.setStartHandler(() {
      setState(() {
        ttsState = TtsState.playing;
      });
    });
    flutterTts.setCompletionHandler(() {
      setState(() {
        ttsState = TtsState.stopped;
        setState(() {});
      });
    });
    flutterTts.setErrorHandler((msg) {
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(customSnackBar(msg));
        ttsState = TtsState.stopped;
        setState(() {});
      });
    });
  }

  _startListen() async {
    await _getPrefs();
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);

    switch (language) {
      case "en":
        _word1 = "Hi, now we will train the word ${wordList[id].enWord}";
        _startWelcome = "In Russian it sounds like this";
        _word2 = wordList[id].ruWord;
        _lang1 = "en";
        _lang2 = "ru";
        break;
      case "ru":
        _word1 =
            "Привет, сейчас будем тренировать слово ${wordList[id].ruWord}";
        _startWelcome = "По английски оно звучит таким образом";
        _word2 = wordList[id].enWord;
        _lang1 = "ru";
        _lang2 = "en";
        break;
    }

    var result;
    await flutterTts.setLanguage(_lang1);
    if (_speakerStatus) result = await flutterTts.speak(_word1);

    if (_speakerStatus != true) {
      _stopListen();
    }
    if (_speakerStatus) await Future.delayed(Duration(seconds: 4));
    if (_speakerStatus) result = await flutterTts.speak(_startWelcome);

    if (_speakerStatus) await Future.delayed(Duration(seconds: 3));

    if (_speakerStatus) await flutterTts.setLanguage(_lang2);
    if (_speakerStatus) result = await flutterTts.speak(_word2);

    if (result == 1) setState(() => ttsState = TtsState.playing);

    if (_speakerStatus == false) {
      _stopListen();
    }

    await Future.delayed(Duration(seconds: 1));
  }

  _stopListen() async {
    var result = await flutterTts.stop();
    if (result == 1) setState(() => ttsState = TtsState.stopped);
  }

  @override
  Widget build(BuildContext context) {
    Future<Null> _timer() async {
      if (_timerSec > 5) setState(() => _timerSec = 5);

      while (_timerSec != 0) {
        await Future.delayed(Duration(milliseconds: 1000));
        setState(() => _timerSec--);

        if (!_speakerStatus) {
          setState(() => _timerSec = 999);
          break;
        }
      }
      _timerSec = 999;
    }

    Future<Null> _welcomeVoice() async {
      while (_speakerStatus) {
        _i++;
        await _startListen();
        if (_speakerStatus == false) break;
        await _stopListen();
        await _timer();
        if (_speakerStatus == false) break;
        await _listen();
        ScaffoldMessenger.of(context).showSnackBar(customSnackBar(_checkWord));
        await _checkStop();
      }

      await _stop();
    }

    _textSpanEnTrans() {
      return TextSpan(
          text: "[${wordList[id].enTrans}]\n",
          style: TextStyle(fontSize: 20.0));
    }

    _textSpanRuTrans() {
      return TextSpan(
          text: "[${wordList[id].ruTrans}]\n",
          style: TextStyle(fontSize: 20.0));
    }

    Widget textSpeaker = Column(
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: language == "en"
                ? "\n${wordList[id].enWord}\n"
                : "\n${wordList[id].ruWord}\n",
            style: TextStyle(
                fontSize: 36.0,
                fontWeight: FontWeight.bold,
                color: Colors.black),
            children: [
              language == "en" ? _textSpanEnTrans() : _textSpanRuTrans(),
              TextSpan(
                  text: "Статистика - спросить: $countRepeat\n",
                  style: TextStyle(fontSize: 20.0)),
              TextSpan(
                  text: "Статистика - спросил: $_i\n",
                  style: TextStyle(fontSize: 20.0)),
              TextSpan(text: "\n\n"),
              TextSpan(
                text: language == "en"
                    ? "${wordList[id].ruWord}\n"
                    : "${wordList[id].enWord}\n",
                style: TextStyle(
                    fontSize: 36.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              TextSpan(
                  text: "[ $_lastWords ]\n", style: TextStyle(fontSize: 20.0)),
              TextSpan(
                  text: "Статистика верно: $_check",
                  style: TextStyle(fontSize: 20.0)),
            ],
          ),
        )
      ],
    );

    Widget playerSpeaker = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          onPressed: () {
            if (repeatCircle != 2)
              setState(() => repeatCircle++);
            else
              setState(() => repeatCircle = 0);
            _savePrefs();
          },
          iconSize: 45.0,
          icon: Icon(
            repeatCircle == 0
                ? Icons.repeat
                : repeatCircle == 1
                    ? Icons.repeat_one_outlined
                    : Icons.repeat_on_outlined,
            color: repeatCircle == 0 ? Colors.grey[500] : Colors.black,
          ),
        ),
        IconButton(
          onPressed: id == 0
              ? null
              : () {
                  if (id != 0) setState(() => id--);
                },
          iconSize: 40.0,
          icon: Icon(
            Icons.arrow_back,
            color: id != 0 ? Colors.black : Colors.grey[500],
          ),
        ),
        IconButton(
          onPressed: () {
            _getPrefs();
            setState(() => _speakerStatus = !_speakerStatus);
            if (_speakerStatus) {
              setState(() {
                cutRecord = true;
                _check = 0;
                _i = 0;
              });
              _welcomeVoice();
            } else {
              _stop();
              setState(() {
                cutRecord = false;
                _speakerStatus = false;
              });
            }
          },
          iconSize: 90.0,
          icon: Icon(
            _speakerStatus == false ? Icons.mic_none : Icons.mic_off_outlined,
          ),
        ),
        IconButton(
          onPressed: id == wordList.length - 1 && repeatCircle == 0
              ? null
              : () {
                  if (id == wordList.length - 1 && repeatCircle == 1)
                    setState(() {
                      id = 0;
                      repeatCircle = 0;
                    });
                  if (id == wordList.length - 1 && repeatCircle == 2)
                    setState(() => id = 0);
                  if (_randomPlay) _randomNextWord();
                  if (id != wordList.length - 1) setState(() => id++);
                },
          iconSize: 40.0,
          icon: Icon(
            Icons.arrow_forward,
            color: id != wordList.length - 1 ? Colors.black : Colors.grey[500],
          ),
        ),
        IconButton(
          onPressed: () {
            setState(() => _randomPlay = !_randomPlay);
            _savePrefs();
          },
          iconSize: 50.0,
          icon: Icon(
            Icons.alt_route_outlined,
            color: _randomPlay == false ? Colors.grey[500] : Colors.black,
          ),
        ),
      ],
    );

    return Stack(alignment: Alignment.center,
        // fit: StackFit.expand,
        // overflow: Overflow.visible,
        children: [
          Column(
            children: [
              Expanded(
                  flex: 7,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.grey[300],
                    child: textSpeaker,
                  )),
              // Expanded(
              //     flex: 1,
              //     child: Container(
              //       width: MediaQuery
              //           .of(context)
              //           .size
              //           .width,
              //       color: widget.type == '' ? Colors.red[200] : Colors.blue[100],
              //     )),
              Expanded(
                  flex: 3,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: playerSpeaker,
                    color: Colors.grey[300],
                  )),
            ],
          ),
          _timerSec == 999
              ? Container()
              : ClipOval(
                  // clipper: CustomClip(),

                  child: Container(
                    alignment: Alignment.center,
                    width: 200.0,
                    height: 300.0,
                    decoration: BoxDecoration(
                        gradient: RadialGradient(
                      colors: [
                        Colors.white,
                        Colors.grey[300],
                      ],
                      stops: [0.5, 1.0],
                    )),
                    // alignment: Alignment.center,
                    child: Text(
                      _timerSec == 999 ? " " : "$_timerSec",
                      style: TextStyle(
                        fontSize: 100.0,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ),
        ]);
  }
}
