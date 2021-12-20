import 'package:encho/commons/models/provider_model.dart';
import 'package:encho/commons/models/words_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences prefs;

  String language;
  double pitch = 1.0;
  double rate = 0.5;
  double countRepeat = 1.0;
  double delayRepeat = 3.0;
  double delayBetweenWords = 3.0;

  void initState() {
    super.initState();
    _getPrefs();
  }

  _getPrefs() async {
    prefs = await _prefs;
    setState(() {
      pitch = (prefs.getDouble("PITCH") ?? 1.0);
      rate = (prefs.getDouble("RATE") ?? 0.5);
      countRepeat = (prefs.getInt("COUNT_REPEAT").toDouble() ?? 1);
      delayRepeat = (prefs.getInt("DELAY_REPEAT").toDouble() ?? 3);
      delayBetweenWords = (prefs.getInt("DELAY_BETWEEN_WORDS").toDouble() ?? 3);
      language = (prefs.getString("CORRECT_LANGUAGE") ?? "");
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<ProviderModel>(context);
    final _provLang = _provider.correctLang;
    final _provPitch = _provider.pitch;
    final _provRate = _provider.rate;
    final _provCountRepeat = _provider.countRepeat;
    final _provDelayRepeat = _provider.delayRepeat;
    final _provDelayBetweenWords = _provider.delayBetweenWords;

    setPitch() {
      return Column(children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: Text(
            "Pitch",
            style: TextStyle(fontSize: 18.0),
          ),
        ),
        Divider(
          indent: 25.0,
          endIndent: 25.0,
          height: 5.0,
          thickness: 2.0,
          color: Colors.blueGrey[100],
        ),
        Slider(
          value: _provPitch,
          onChanged: (newPitch) {
            setState(() => _provider.changePitch(newPitch));
          },
          min: 0.5,
          max: 2.0,
          divisions: 15,
          activeColor: Colors.blueGrey[300],
          thumbColor: Colors.grey[400],
          inactiveColor: Colors.blueGrey[100],
          label: "Pitch: $_provPitch",
        ),
        Divider(
          indent: 5.0,
          endIndent: 5.0,
          height: 5.0,
          thickness: 2.0,
          color: Colors.blueGrey[200],
        ),
      ]);
    }

    setRate() {
      return Column(children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: Text(
            "Rate",
            style: TextStyle(fontSize: 18.0),
          ),
        ),
        Divider(
          indent: 25.0,
          endIndent: 25.0,
          height: 5.0,
          thickness: 2.0,
          color: Colors.blueGrey[100],
        ),
        Slider(
          value: _provRate,
          onChanged: (newRate) {
            setState(() => _provider.changeRate(newRate));
          },
          min: 0.1,
          max: 1.0,
          divisions: 10,
          activeColor: Colors.blueGrey[300],
          thumbColor: Colors.grey[400],
          inactiveColor: Colors.blueGrey[100],
          label: "Rate: $_provRate",
        ),
        Divider(
          indent: 5.0,
          endIndent: 5.0,
          height: 5.0,
          thickness: 2.0,
          color: Colors.blueGrey[200],
        ),
      ]);
    }

    setCountRepeat() {
      return Column(children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: Text(
            "Count of repeat",
            style: TextStyle(fontSize: 18.0),
          ),
        ),
        Divider(
          indent: 25.0,
          endIndent: 25.0,
          height: 5.0,
          thickness: 2.0,
          color: Colors.blueGrey[100],
        ),
        Slider(
          value: _provCountRepeat,
          onChanged: (newCount) {
            setState(() => _provider.changeCountRepeat(newCount));
          },
          min: 1.0,
          max: 7.0,
          divisions: 6,
          activeColor: Colors.blueGrey[300],
          thumbColor: Colors.grey[400],
          inactiveColor: Colors.blueGrey[100],
          label: "Count of repeat: $_provCountRepeat",
        ),
        Divider(
          indent: 5.0,
          endIndent: 5.0,
          height: 5.0,
          thickness: 2.0,
          color: Colors.blueGrey[200],
        ),
      ]);
    }

    setDelayRepeat() {
      return Column(children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: Text(
            "Delay of repeat",
            style: TextStyle(fontSize: 18.0),
          ),
        ),
        Divider(
          indent: 25.0,
          endIndent: 25.0,
          height: 5.0,
          thickness: 2.0,
          color: Colors.blueGrey[100],
        ),
        Slider(
          value: _provDelayRepeat,
          onChanged: (newDelay) {
            setState(() => _provider.changeDelayRepeat(newDelay));
          },
          min: 3.0,
          max: 9.0,
          divisions: 6,
          activeColor: Colors.blueGrey[300],
          thumbColor: Colors.grey[400],
          inactiveColor: Colors.blueGrey[100],
          label: "Delay of repeat: $_provDelayRepeat",
        ),
        Divider(
          indent: 5.0,
          endIndent: 5.0,
          height: 5.0,
          thickness: 2.0,
          color: Colors.blueGrey[200],
        ),
      ]);
    }

    setDelayBetweenWords() {
      return Column(children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: Text(
            "Setting the delay between words ",
            style: TextStyle(fontSize: 18.0),
          ),
        ),
        Divider(
          indent: 25.0,
          endIndent: 25.0,
          height: 5.0,
          thickness: 2.0,
          color: Colors.blueGrey[100],
        ),
        Slider(
          value: _provDelayBetweenWords,
          onChanged: (newDelay) {
            setState(() => _provider.changeBetweenWords(newDelay));
          },
          min: 1.0,
          max: 7.0,
          divisions: 6,
          activeColor: Colors.blueGrey[300],
          thumbColor: Colors.grey[400],
          inactiveColor: Colors.blueGrey[100],
          label: "Setting the delay between words: $_provDelayBetweenWords",
        ),
        Divider(
          indent: 5.0,
          endIndent: 5.0,
          height: 5.0,
          thickness: 2.0,
          color: Colors.blueGrey[200],
        ),
      ]);
    }

    setLanguage() {
      return Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              "Language",
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          Divider(
            indent: 25.0,
            endIndent: 25.0,
            height: 5.0,
            thickness: 2.0,
            color: Colors.blueGrey[100],
          ),
          DropdownButton<String>(
              hint: Text("Choose the language"),
              value: _provLang,
              onChanged: (value) {
                setState(() {
                  _provider.changeLang(value);
                });
              },
              items: langs.map((item) {
                return DropdownMenuItem<String>(
                    value: item, child: Text(item));
              }).toList()),
          Text(
              "Chosen language: ${_provLang == null ? "not chosen" : _provLang}"),
        ],
      );
    }

    _savePrefs() async {
      prefs = await _prefs;
      await prefs.setDouble("PITCH", _provPitch);
      await prefs.setDouble("RATE", _provRate);
      await prefs.setInt("COUNT_REPEAT", _provCountRepeat.toInt());
      await prefs.setInt("DELAY_REPEAT", _provDelayRepeat.toInt());
      await prefs.setInt("DELAY_BETWEEN_WORDS", _provDelayBetweenWords.toInt());
      await prefs.setString("CORRECT_LANGUAGE", _provLang);
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Settings'),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
            _savePrefs();
          },
          child: Icon(Icons.arrow_back),
        ),
      ),
      body: ListView(
        children: [
          setPitch(),
          setRate(),
          setLanguage(),
          setCountRepeat(),
          setDelayRepeat(),
          setDelayBetweenWords(),
        ],
      ),
    );
  }
}
