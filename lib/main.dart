import 'package:bbv_learning_flutter/transaction_item.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}
  class MyHomePage extends StatelessWidget {
    MyHomePage({Key? key}) : super(key: key);

    List<TransactionItem> items = <TransactionItem>[
      TransactionItem("100", "Buy new shoes"),
      TransactionItem('20', "Buy vietlot")
    ];

    @override
    Widget build(BuildContext context) {
      return Scaffold(
          body: SafeArea(
            child: Container(
              margin: new EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: Colors.deepPurpleAccent,
                          ),
                          child:  Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                                Container(
                                    margin: new EdgeInsets.only(left: 10.0),
                                  child:  const Text(
                                      'Expense Notes',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                    )
                                )
                            ],
                          )
                      )
                  ),
                  Expanded(
                      flex: 5,
                      child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: Colors.green,
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
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Colors.yellow,
                      ),
                      child: Container(
                        margin: new EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Transaction list",
                                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))),
                            Expanded(
                                child: ListView.builder(
                                    itemCount: 2,
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
                  )
                ],
              ),
            ),
          ) // This trailing comma makes auto-formatting nicer for build methods.
      );
    }
}
