import 'package:flutter/material.dart';
import '../models/list_item.dart';
import '../util/dbhelper.dart';

class ListItemDialog {
  late final txtName = TextEditingController();
  late final txtQuantity = TextEditingController();
  late final txtNote = TextEditingController();
  Widget buildAlert(BuildContext context, ListItem item, bool isNew) {
    DbHelper? helper = DbHelper();
    helper.openDb();
    if (!isNew) {
      txtName.text = item.name;
      txtQuantity.text = item.quantity;
      txtNote.text = item.note;
    }
    return AlertDialog(
      title: Text((isNew) ? 'New shopping item' : 'Edit shopping item'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextField(
                controller: txtName,
                decoration: InputDecoration(hintText: 'Item Name')),
            TextField(
              controller: txtQuantity,
              decoration: InputDecoration(hintText: 'Quantity'),
            ),
            TextField(
              controller: txtNote,
              decoration: InputDecoration(hintText: 'Note'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.teal[700], // background
                padding: EdgeInsets.all(10),
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)), // foreground
              ),
              child: Text("Save Item"),
              onPressed: () {
                item.name = txtName.text;
                item.quantity = txtQuantity.text;
                item.note = txtNote.text;
                helper.insertItem(item);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
