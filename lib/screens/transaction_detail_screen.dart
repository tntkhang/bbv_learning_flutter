import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class TransactionDetailScreen extends StatelessWidget {
  const TransactionDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    String transactionTitle = arg['transactionTitle'];
    String transactionDes = arg['transactionDes'];

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
