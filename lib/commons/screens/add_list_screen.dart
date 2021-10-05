import 'package:encho/commons/widgets/add_buttons.dart';
import 'package:flutter/material.dart';

import '../test_list.dart';

class AddListScreen extends StatefulWidget{

  @override
  _AddListScreenState createState() => _AddListScreenState();
}

class _AddListScreenState extends State<AddListScreen>{
  @override
  Widget build(BuildContext context) {
    List<TestList> reverseList = testList.reversed.toList();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          flex: 9,
          child: ListView.separated(
            itemCount: reverseList.length,
            itemBuilder: (BuildContext context, int index) => TestCard(
              getTestString: reverseList[index].test1,
              getTestInt: reverseList[index].test2,
            ),
            separatorBuilder: (BuildContext context, int index) => Container(
              width: MediaQuery.of(context).size.width - 75,
              height: 10.0,
              color: Colors.red[100],
            ),
          ),
        ),

        Expanded(flex: 1, child: AddButtonsWidget("list")),
      ],
    );
  }

}