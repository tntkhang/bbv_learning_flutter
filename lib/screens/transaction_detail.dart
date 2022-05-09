import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class TransactionDetailScreen extends StatelessWidget {
  String transactionTitle = '';
  String transactionDes = '';
  TransactionDetailScreen({Key? key,
      required this.transactionTitle,
      required this.transactionDes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
        appBar: PlatformAppBar(
            title: PlatformText(transactionTitle, style: const TextStyle(color: Colors.white)),
        ),
        body: Center(
          child: PlatformText(transactionDes)
        )
    );
  }
}
