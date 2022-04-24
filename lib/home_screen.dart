import 'package:bbv_learning_flutter/transaction_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {

    List<TransactionItem> items = <TransactionItem>[
      TransactionItem(10, "Buy new shoes", "25-02-2022"),
      TransactionItem(20, "Buy vietlot", "25-02-2022"),
      TransactionItem(100, "Buy new shoes", "25-02-2022"),
    ];

    addTransaction()  {

    }

    showBottomSheetAddTransaction() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Wrap(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: "Name"
                  ),
                  keyboardType: TextInputType.text,
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: "Amount"
                  ),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: "Name"
                  ),
                  keyboardType: TextInputType.datetime,
                ),
                TextButton(onPressed: addTransaction, child: Text("Amount"))
              ],
            );
          });
    }

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          TextButton(
            onPressed: () {},
            child: Text('Save'),
          ),
        ],
        title: Text('My App'),
        centerTitle: false,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
                flex: 5,
                child: Container(
                    margin: new EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 0), // Shadow position
                        ),
                      ],
                      color: Colors.white,
                    ),
                    child: const Center(
                        child: Text(
                            'Chart',
                            style: TextStyle(fontSize: 30)
                        )
                    )
                )
            ),
            Expanded(
                flex: 8,
                  child: Container(
                      margin: new EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Transaction list",
                                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))),
                          Expanded(
                              child: ListView.builder(
                                  itemCount: items.length,
                                  itemBuilder: (BuildContext context,int index){
                                    return Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.black),
                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                          color: Colors.white,
                                        ),
                                        child: ListTile(
                                            leading: Text("\$" + items[index].amount,
                                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                            title:Text(items[index].title,
                                                style: TextStyle(fontSize: 20))
                                        )
                                    );
                                  }
                              )
                          )
                        ],
                      )
                  ),
                )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showBottomSheetAddTransaction();
        },
        backgroundColor: Colors.purple,
        child: const Icon(Icons.add),
      ),
    );
  }
}
