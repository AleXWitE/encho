import 'package:encho/commons/test_list.dart';
import 'package:encho/commons/widgets/add_buttons.dart';
import 'package:flutter/material.dart';

class AddOneScreen extends StatefulWidget {
  @override
  _AddOneScreenState createState() => _AddOneScreenState();
}

class _AddOneScreenState extends State<AddOneScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          flex: 9,
          child: ListView.separated(
            itemCount: testList.length,
            itemBuilder: (BuildContext context, int index) => TestCard(
              getTestString: testList[index].test1,
              getTestInt: testList[index].test2,
            ),
            separatorBuilder: (BuildContext context, int index) => Container(
              width: MediaQuery.of(context).size.width - 75,
              height: 10.0,
              color: Colors.grey[100],
            ),
          ),
        ),

        Expanded(flex: 1,child: AddButtonsWidget("one")),
      ],
    );
  }
}
