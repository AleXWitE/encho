import 'dart:math';

import 'package:encho/commons/models/words_model.dart';
import 'package:encho/commons/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum TtsState { playing, stopped }

class ListeningScreen extends StatefulWidget {
  @override
  _ListeningScreenState createState() => _ListeningScreenState();
}

class _ListeningScreenState extends State<ListeningScreen> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences prefs;

  int countRepeat;
  int delayRepeat;
  int delayBetweenWords;

  int repeatCircle = 0;
  bool randomPlay;

  dynamic languages;

  String language;
  String _lang1;
  String _lang2;

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;

  get isStopped => ttsState == TtsState.stopped;

  double volume;
  double pitch;
  double rate;

  String _word1;
  String _word2;

  bool _playerStatus = false;

  FlutterTts flutterTts;

  int id = 0;
  int i = 0;

  void initState() {
    super.initState();
    _initTts();
    _getPrefs();
    _getRepeatAndRandom();
  }

  _getRepeatAndRandom() async {
    prefs = await _prefs;
    setState(() {
      repeatCircle = (prefs.getInt("REPEAT_CIRCLE") ?? 0);
      randomPlay = (prefs.getBool("RANDOM_PLAY") ?? false);
    });
  }

  _initTts() {
    flutterTts = FlutterTts();

    _getLanguages();
    print("languages = $languages");

    flutterTts.setStartHandler(() {
      setState(() {
        print("playing");
        ttsState = TtsState.playing;
      });
    });
    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        // ttsState = TtsState.stopped;
        // setState(() => _playerStatus = false);
      });
    });
    flutterTts.setErrorHandler((msg) {
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(customSnackBar(msg));
        ttsState = TtsState.stopped;
        setState(() => _playerStatus = false);
      });
    });
  }

  _getPrefs() async {
    prefs = await _prefs;
    volume = (prefs.getDouble("VOLUME") ?? 0.5);
    pitch = (prefs.getDouble("PITCH") ?? 1.0);
    rate = (prefs.getDouble("RATE") ?? 0.5);
    language = (prefs.getString("CORRECT_LANGUAGE") ?? "ru");
    countRepeat = (prefs.getInt("COUNT_REPEAT") ?? 1);
    delayRepeat = (prefs.getInt("DELAY_REPEAT") ?? 3);
    delayBetweenWords = (prefs.getInt("DELAY_BETWEEN_WORDS") ?? 3);
  }

  Future<dynamic> _getLanguages() => languages = flutterTts.getLanguages;

  _play() async {
    await _getPrefs();
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);
    setState(() => _playerStatus = true);

    switch (language) {
      case "en":
        _word1 = wordList[id].enWord;
        _word2 = wordList[id].ruWord;
        _lang1 = "en";
        _lang2 = "ru";
        break;
      case "ru":
        _word1 = wordList[id].ruWord;
        _word2 = wordList[id].enWord;
        _lang1 = "ru";
        _lang2 = "en";
        break;
    }
    var result;
    while (i < countRepeat && _playerStatus == true) {
      await flutterTts.setLanguage(_lang1);
      result = await flutterTts.speak(_word1);
      if (_playerStatus == false) {
        _pause();
        break;
      }

      await Future.delayed(Duration(seconds: delayBetweenWords));

      await flutterTts.setLanguage(_lang2);
      if (_playerStatus) result = await flutterTts.speak(_word2);

      if (result == 1) setState(() => ttsState = TtsState.playing);

      await Future.delayed(Duration(seconds: i == countRepeat - 1 ? delayRepeat + 3 : delayRepeat));
      i++;
      if (_playerStatus == false) {
        _pause();
        break;
      }
    }

    i = 0;

    if (_playerStatus == true) {
      if (randomPlay)
        randomNextWord();
      else if (id != wordList.length - 1)
        setState(() => id++);
      else if (id == wordList.length - 1 && repeatCircle == 2)
        setState(() => id = 0);
      else if (id == wordList.length - 1 && repeatCircle == 1) {
        setState(() {
          repeatCircle = 0;
          id = 0;
        });
      } else
        setState(() => _playerStatus = false);
    }

    if (_playerStatus == true)
      _play();
    else
      _pause();
  }

  _pause() async {
    var result = await flutterTts.stop();
    if (result == 1) setState(() => ttsState = TtsState.stopped);
    setState(() => i = 0);
  }

  randomNextWord() {
    setState(() => id = Random().nextInt(wordList.length - 2));
  }

  void dispose() {
    super.dispose();
    _savePrefs();
    _pause();
    _playerStatus = false;
  }

  _savePrefs() async {
    prefs = await _prefs;
    await prefs.setInt("REPEAT_CIRCLE", repeatCircle);
    await prefs.setBool("RANDOM_PLAY", randomPlay);
  }

  _resetPrefs() async {
    prefs = await _prefs;
    setState(() {
      volume = 0.5;
      pitch = 1.0;
      rate = 0.5;
      countRepeat = 1;
      delayRepeat = 3;
      delayBetweenWords = 3;
      language = "en";
    });
    await prefs.setDouble("VOLUME", volume);
    await prefs.setDouble("PITCH", pitch);
    await prefs.setDouble("RATE", rate);
    await prefs.setInt("COUNT_REPEAT", countRepeat);
    await prefs.setInt("DELAY_REPEAT", delayRepeat);
    await prefs.setInt("DELAY_BETWEEN_WORDS", delayBetweenWords);
    await prefs.setString("CORRECT_LANGUAGE", language);
  }

  _textSpanEnTrans() {
    return TextSpan(
        text: "[${wordList[id].enTrans}]", style: TextStyle(fontSize: 20.0));
  }

  _textSpanRuTrans() {
    return TextSpan(
        text: "[${wordList[id].ruTrans}]", style: TextStyle(fontSize: 20.0));
  }

  _resetButton() {
    return MaterialButton(
      child: Text(
        "Reset settings",
        style: TextStyle(),
      ),
      onPressed: () => _resetPrefs(),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget textListen = Column(
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
              TextSpan(text: "\n\n"),
              TextSpan(
                text: language == "en"
                    ? "\n${wordList[id].ruWord}\n"
                    : "\n${wordList[id].enWord}\n",
                style: TextStyle(
                    fontSize: 36.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              language == "en" ? _textSpanRuTrans() : _textSpanEnTrans(),
              TextSpan(text: "\n\n\n"),
              TextSpan(
                  text: "Count of repeat: x",
                  style: TextStyle(fontSize: 20.0, color: Colors.grey[500])),
              TextSpan(
                  text: "$countRepeat",
                  style: TextStyle(fontSize: 30.0, color: Colors.grey[500]))
            ],
          ),
        )
      ],
    );

    Widget playerListen = Row(
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
                  _pause();
                },
          iconSize: 40.0,
          icon: Icon(
            Icons.arrow_back,
            color: id != 0 ? Colors.black : Colors.grey[500],
          ),
        ),
        IconButton(
          onPressed: () async {
            if (_playerStatus)
              _pause();
            else
              _play();
            setState(() {
              _playerStatus = !_playerStatus;
            });
          },
          iconSize: 90.0,
          icon: _playerStatus == true
              ? Icon(
                  Icons.pause_circle_outline,
                )
              : Icon(
                  Icons.play_circle_outline,
                  size: 90.0,
                ),
        ),
        IconButton(
          onPressed: id == wordList.length - 1 && repeatCircle == 0
              ? null
              : () async {
                  if (id == wordList.length - 1 && repeatCircle == 1)
                    setState(() {
                      id = 0;
                      repeatCircle = 0;
                    });
                  if (id == wordList.length - 1 && repeatCircle == 2)
                    setState(() => id = 0);
                  if (randomPlay) randomNextWord();
                  if (id != wordList.length - 1) setState(() => id++);
                  setState(() => i = 0);
                  // _pause();
                  // await flutterTts.stop();
                  if (_playerStatus == true)
                    _play();
                  else
                    _pause();
                },
          iconSize: 40.0,
          icon: Icon(
            Icons.arrow_forward,
            color: id != wordList.length - 1 || repeatCircle != 0
                ? Colors.black
                : Colors.grey[500],
          ),
        ),
        IconButton(
          onPressed: () {
            setState(() => randomPlay = !randomPlay);
            _savePrefs();
          },
          iconSize: 50.0,
          icon: Icon(
            Icons.alt_route_outlined,
            color: randomPlay == false ? Colors.grey[500] : Colors.black,
          ),
        ),
      ],
    );

    return Column(
      children: [
        Expanded(
            flex: 7,
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.grey[300],
              child: textListen,
            )),
        Expanded(
            flex: 1,
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.grey[300],
              padding: EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 5.0),
              child: _resetButton(),
            )),
        Expanded(
            flex: 3,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: playerListen,
              color: Colors.grey[300],
            )),
      ],
    );
  }
}
