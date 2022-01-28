import 'package:flutter/material.dart';

import '../class.dart';
import '../framework.dart';

class emptyFilter extends FilterPanelWidget {
  final Widget? child;

  emptyFilter({
    Key? key,
    this.child,
  }) : super(key: key);

  @override
  emptyFilterState createState() => emptyFilterState();
}

class emptyFilterState extends State<emptyFilter> {
  @override
  void initState() {
    super.initState();

    widget.data = FilterPanelData(
      value: null,
      name: "emptyFilter"
    );
  }

  @override
  build(BuildContext context) {
    return widget.child!;
  }
}
