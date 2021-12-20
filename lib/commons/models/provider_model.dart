import 'package:flutter/material.dart';

class ProviderModel extends ChangeNotifier {
  String correctLang = "en";
  double pitch = 1.0;
  double rate = 0.5;
  double countRepeat = 1.0;
  double delayRepeat = 3.0;
  double delayBetweenWords = 3.0;

  void changeLang(String _input){
    correctLang = _input;
    notifyListeners();
  }

  void changePitch(double _input){
    pitch = _input;
    notifyListeners();
  }

  void changeRate(double _input){
    rate = _input;
    notifyListeners();
  }

  void changeCountRepeat(double _input){
    countRepeat = _input;
    notifyListeners();
  }

  void changeDelayRepeat(double _input){
    delayRepeat = _input;
    notifyListeners();
  }

  void changeBetweenWords(double _input){
    delayBetweenWords = _input;
    notifyListeners();
  }
}