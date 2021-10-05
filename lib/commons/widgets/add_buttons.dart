import 'package:flutter/material.dart';

class AddButtonsWidget extends StatefulWidget {
  String type;

  AddButtonsWidget( this.type) : super();
  @override
  _AddButtonsWidgetState createState() => _AddButtonsWidgetState();
}

class _AddButtonsWidgetState extends State<AddButtonsWidget> {
  _add(){

  }

  _delete(){

  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        MaterialButton(
          color: Colors.grey[400],
          child: Row(children: [
            Icon(Icons.add),
            SizedBox(width: 15.0,),
            Text("Add"),
          ],),
          minWidth: 150.0,
          onPressed: () {
          _add();
        },),
        MaterialButton(
          color: Colors.grey[400],
          child: Row(children: [
            Icon(Icons.delete_forever),
            SizedBox(width: 15.0,),
            Text("Delete"),
          ],),
          minWidth: 150.0,
          onPressed: () {
          _delete();
        },),
      ],
    );
  }
}
