import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class actionsFilterWidget extends StatelessWidget {
  final Function? onReset;
  final Function? onChange;

  const actionsFilterWidget({
    Key? key,
    this.onReset,
    this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).buttonTheme.colorScheme!.primary,
      child: ButtonBar(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        // crossAxisAlignment: CrossAxisAlignment.center,
        alignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        buttonAlignedDropdown: true,
        overflowButtonSpacing: 10.0,
        buttonMinWidth: 100,
        buttonHeight: 100,
        buttonTextTheme: ButtonTextTheme.primary,
        buttonPadding: EdgeInsets.zero,
        children: <Widget>[
          TextButton(
            child: Text(
              "重置",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () => onReset!(),
          ),
          TextButton(
            child: Text(
              "确定",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () => onChange!(),
          ),
        ],
      ),
    );
  }
}
