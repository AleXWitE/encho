import 'package:encho/commons/models/words_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences prefs;

  Languages language;
  String _language;
  double volume = 0.5;
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
      volume = (prefs.getDouble("VOLUME") ?? 0.5);
      pitch = (prefs.getDouble("PITCH") ?? 1.0);
      rate = (prefs.getDouble("RATE") ?? 0.5);
      countRepeat = (prefs.getInt("COUNT_REPEAT").toDouble() ?? 1);
      delayRepeat = (prefs.getInt("DELAY_REPEAT").toDouble() ?? 3);
      delayBetweenWords = (prefs.getInt("DELAY_BETWEEN_WORDS").toDouble() ?? 3);
      _language = (prefs.getString("CORRECT_LANGUAGE") ?? "");
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setVolume() {
      return Column(children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: Text(
            "Volume",
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
          value: volume,
          onChanged: (newVolume) {
            setState(() => volume = newVolume);
          },
          min: 0.0,
          max: 1.0,
          divisions: 10,
          activeColor: Colors.blueGrey[300],
          thumbColor: Colors.grey[400],
          inactiveColor: Colors.blueGrey[100],
          label: "Volume: $volume",
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
          value: pitch,
          onChanged: (newPitch) {
            setState(() => pitch = newPitch);
          },
          min: 0.5,
          max: 2.0,
          divisions: 15,
          activeColor: Colors.blueGrey[300],
          thumbColor: Colors.grey[400],
          inactiveColor: Colors.blueGrey[100],
          label: "Pitch: $pitch",
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
          value: rate,
          onChanged: (newRate) {
            setState(() => rate = newRate);
          },
          min: 0.1,
          max: 1.0,
          divisions: 10,
          activeColor: Colors.blueGrey[300],
          thumbColor: Colors.grey[400],
          inactiveColor: Colors.blueGrey[100],
          label: "Rate: $rate",
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
          value: countRepeat,
          onChanged: (newCount) {
            setState(() => countRepeat = newCount);
          },
          min: 1.0,
          max: 7.0,
          divisions: 6,
          activeColor: Colors.blueGrey[300],
          thumbColor: Colors.grey[400],
          inactiveColor: Colors.blueGrey[100],
          label: "Count of repeat: $countRepeat",
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
          value: delayRepeat,
          onChanged: (newDelay) {
            setState(() => delayRepeat = newDelay);
          },
          min: 3.0,
          max: 9.0,
          divisions: 6,
          activeColor: Colors.blueGrey[300],
          thumbColor: Colors.grey[400],
          inactiveColor: Colors.blueGrey[100],
          label: "Delay of repeat: $delayRepeat",
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
          value: delayBetweenWords,
          onChanged: (newDelay) {
            setState(() => delayBetweenWords = newDelay);
          },
          min: 1.0,
          max: 7.0,
          divisions: 6,
          activeColor: Colors.blueGrey[300],
          thumbColor: Colors.grey[400],
          inactiveColor: Colors.blueGrey[100],
          label: "Setting the delay between words: $delayBetweenWords",
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
          DropdownButton<Languages>(
              hint: Text("Choose the language"),
              value: language,
              onChanged: (value) {
                setState(() {
                  language = value;
                  _language = value.lang;
                });
              },
              items: langs.map((item) {
                return DropdownMenuItem<Languages>(
                    value: item, child: Text(item.lang));
              }).toList()),
          Text(
              "Chosen language: ${_language == null ? "not chosen" : _language}"),
        ],
      );
    }

    _savePrefs() async {
      prefs = await _prefs;
      await prefs.setDouble("VOLUME", volume);
      await prefs.setDouble("PITCH", pitch);
      await prefs.setDouble("RATE", rate);
      await prefs.setInt("COUNT_REPEAT", countRepeat.toInt());
      await prefs.setInt("DELAY_REPEAT", delayRepeat.toInt());
      await prefs.setInt("DELAY_BETWEEN_WORDS", delayBetweenWords.toInt());
      await prefs.setString("CORRECT_LANGUAGE", language.lang.toString());
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
          setVolume(),
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
