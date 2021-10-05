import 'package:flutter/material.dart';

class TestList{
  String test1;
  int test2;

  TestList(this.test1, this.test2);
}

List<TestList> testList = [
  TestList("test1", 1),
  TestList("test2", 2),
  TestList("test3", 3),
  TestList("test4", 4),
  TestList("test5", 5),
  TestList("test6", 6),
  TestList("test7", 7),
  TestList("test8", 8),
  TestList("test9", 9),
  TestList("test10", 10),
  TestList("test11", 11),
  TestList("test12", 12),
];

class TestCard extends StatefulWidget{
  String getTestString;
  int getTestInt;
  TestCard({Key key, this.getTestString, this.getTestInt }) : super(key: key);

  @override
  _TestCardState createState() => _TestCardState();
}

class _TestCardState extends State<TestCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Text("${widget.getTestString}\n\n${widget.getTestInt}")
    );
  }
}