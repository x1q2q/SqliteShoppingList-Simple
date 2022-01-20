import 'package:flutter/material.dart';
import '../models/shopping_list.dart';
import '../ui/shopping_list_dialog.dart';
import '../ui/items_screen.dart';
import '../util/dbhelper.dart';

class ShopList extends StatefulWidget {
  ShoppingListDialog dialog = ShoppingListDialog();

  @override
  _ShopListState createState() => _ShopListState();
}

class _ShopListState extends State<ShopList> {
  List<ShoppingList>? shoppingList;
  DbHelper? helper = DbHelper();
  ShoppingListDialog? dialog;

  @override
  void initState() {
    dialog = ShoppingListDialog();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    showData();
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping List'),
      ),
      body: ListView.builder(
          itemCount: (shoppingList != null) ? shoppingList?.length : 0,
          itemBuilder: (BuildContext context, int index) {
            var listShopNama = shoppingList?[index].name == null
                ? ''
                : shoppingList![index].name;
            return Dismissible(
                key: Key(listShopNama),
                onDismissed: (direction) {
                  String strName = listShopNama;
                  helper!.deleteList(shoppingList![index]);
                  setState(() {
                    shoppingList!.removeAt(index);
                  });
                  final snackBar = SnackBar(content: Text("$strName deleted"));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                child: ListTile(
                    title: Text(listShopNama),
                    leading: CircleAvatar(
                      child: Text(shoppingList![index].priority.toString()),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ItemsScreen(shoppingList![index])),
                      );
                    },
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => dialog!
                                .buildDialog(
                                    context, shoppingList![index], false));
                      },
                    )));
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) =>
                dialog!.buildDialog(context, ShoppingList(0, '', 0), true),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.teal[400],
      ),
    );
  }

  Future showData() async {
    await helper?.openDb();
    shoppingList = await helper?.getLists();
    if (this.mounted) {
      setState(() {
        shoppingList = shoppingList;
      });
    }
  }
}
