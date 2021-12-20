import 'dart:io';

import 'package:encho/commons/screens/add_one_screen.dart';
import 'package:encho/commons/screens/settings_page.dart';
import 'package:encho/commons/screens/speaking_screen.dart';
import 'package:encho/commons/widgets/home_widget.dart';
import 'package:flutter/material.dart';

import 'add_list_screen.dart';
import 'listening_screen.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int _index;

  String _title = "ENcho";

  bool checkTab;

  void initState() {
    super.initState();
    _index = 0;
    _title = "ENcho\nMain";
    tabController = TabController(length: _bottomNavItems.length, vsync: this);
    checkTab = true;
  }

  TabController tabController;

  var _bottomNavItems = [
    Tab(icon: Icon(Icons.home), text: "Home"),
    Tab(icon: Icon(Icons.add), text: "Add one word"),
    Tab(icon: Icon(Icons.add_to_photos), text: "Paste list of words"),
    Tab(icon: Icon(Icons.play_circle_fill), text: "Listening"),
    Tab(icon: Icon(Icons.mic_rounded), text: "Speaking"),
    Tab(icon: Icon(Icons.account_box), text: "home"),
  ];

  _onChangedScreen(int _index) {
    switch (_index) {
      case 0:
        _title = "ENcho\nMain";
        break;
      case 1:
        _title = "ENcho\nAdd one word";
        break;
      case 2:
        _title = "ENcho\nAdd list of words";
        break;
      case 3:
        _title = "ENcho\nTry to listen words";
        break;
      case 4:
        _title = "ENcho\nTry to speak";
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    Curve curve = Curves.easeInOut;

    _onBackClick() async {
      tabController.animateTo(0,
          duration: Duration(milliseconds: 800), curve: curve);
      setState(() {
        checkTab = true;
        _onChangedScreen(0);
      });
    }

    Widget _scaffold = Scaffold(
      appBar: AppBar(
        leading: checkTab
            ? null
            : GestureDetector(
                child: Icon(Icons.arrow_back),
                onTap: () {
                  tabController.animateTo(0,
                      duration: Duration(milliseconds: 800), curve: curve);
                  _onChangedScreen(0);
                  setState(() {
                    checkTab = true;
                  });
                },
              ),
        centerTitle: true,
        title: Text(_title),
        actions: tabController.index != 3 && tabController.index != 4
            ? null
            : [
                // PopupMenuButton(
                //     itemBuilder: (context) => [
                //       PopupMenuItem(child: Text("Количество проигрований"), value: 1,),
                //       PopupMenuItem(child: Text("Длительность перерыва между оригиналом и переводом"), value: 2,)
                //     ])
                GestureDetector(
                  onTap: () async {
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => SettingsPage())).then((value) {
                      // if(value == true)

                    });
                    // Navigator.pushNamed(context, '/settings');
                  },
                  child: Icon(
                    Icons.settings,
                    size: 30.0,
                  ),
                )
              ],
      ),
      body: Center(
        // child: _body,
        child: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            controller: tabController,
            children: [
              HomeWidget(), //0
              AddOneScreen(), //1
              AddListScreen(), //2
              ListeningScreen(), //3
              SpeakingScreen(), //4
              HomeWidget(), //5
            ]),
      ),
      bottomNavigationBar: TabBar(
        controller: tabController,
        tabs: _bottomNavItems,
        labelColor: Colors.black,
        onTap: (id) {
          setState(() {
            _index = id;
            _onChangedScreen(_index);
            if (id == 0)
              checkTab = true;
            else
              checkTab = false;
          });
        },
      ),
    );

    if (tabController.indexIsChanging)
      setState(() {
        _onChangedScreen(tabController.index);
      });

    return WillPopScope(
        child: _scaffold,
        onWillPop: checkTab
            ? () {
                return showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Text('Are you sure?'),
                          actions: [
                            MaterialButton(
                                child: Text('No'),
                                onPressed: () =>
                                    Navigator.of(context).pop(false)),
                            MaterialButton(
                                child: Text('Yes'), onPressed: () => exit(0)),
                          ],
                        ));
              }
            : () => _onBackClick());
  }
}
