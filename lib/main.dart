import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '_filter/index.dart';
import '_filter/framework.dart';
import '_filter/class.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey<FilterState> _filterKey = GlobalKey();

  // 结果
  List data = [];

  FilterPanelWidget? dateWidget = emptyFilter();

  @override
  void initState() {
    super.initState();
    initDateFilter();
  }

  initDateFilter() {
    dateWidget = emptyFilter(
      child: Container(
        child: SfDateRangePicker(
          onSelectionChanged: onSelectionChanged,
          view: DateRangePickerView.month,
          monthViewSettings: DateRangePickerMonthViewSettings(firstDayOfWeek: 1),
        ),
        margin: EdgeInsets.only(bottom: 20),
      ),
    );
  }

  onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    print(args.value);
    dateWidget!..data!.value = args.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Filter(
            key: _filterKey,
            maxHeight: 300,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: data.map<Widget>((e) {
                  return Text("${e.value}");
                }).toList(),
              ),
            ),
            slot: [
              // FilterItemWidget(
              //   title: Wrap(
              //     crossAxisAlignment: WrapCrossAlignment.center,
              //     children: [
              //       TextButton.icon(
              //         style: ButtonStyle(
              //           backgroundColor: MaterialStateProperty.all(Colors.blue),
              //           textStyle: MaterialStateProperty.all(
              //             TextStyle(
              //               color: Colors.white,
              //             ),
              //           ),
              //         ),
              //         onPressed: null,
              //         icon: Icon(Icons.map),
              //         label: Text("空面板"),
              //       ),
              //     ],
              //   ),
              // ),

              FilterItemWidget(
                title: Text("日历选择器"),
                panel: dateWidget,
              ),
              FilterItemWidget(
                title: Text("面板标题1"),
                panel: TextWidget(
                  filterKey: _filterKey,
                ),
              ),
              FilterItemWidget(
                title: Text("面板标题2"),
                panel: radioListFilter.builder(
                  itemCount: 100,
                  itemBuilder: (BuildContext content, int index, int selectedIndex) {
                    return Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        index.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: index == selectedIndex ? Colors.blue : Colors.black,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
            onChange: (data) {
              setState(() {
                print(data);
                this.data = data;
              });
            },
          ),
        ],
      ),
    );
  }
}

class TextWidget extends FilterPanelWidget {
  final filterKey;

  TextWidget({
    Key? key,
    this.filterKey,
  }) : super(key: key);

  @override
  textWidgetState createState() => textWidgetState();
}

class textWidgetState extends State<TextWidget> {
  @override
  void initState() {
    super.initState();

    widget.data = FilterPanelData(
      value: "暂无数据",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          margin: EdgeInsets.all(20),
          child: Text("data: ${widget.data!.value}"),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              widget.data!.value = "改变了";
            });
          },
          child: Text("改变数据"),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              widget.data!.value = widget.getPanelData("1").value;
            });
          },
          child: Text("获取 面板标题3的数据"),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              // 改变对应面板数据
              // 应当注意对方面板的数据类型, 这里使用的是radioListFilter
              // 所以value的值是整型
              widget.setPanelData(
                "1",
                FilterPanelData(
                  value: 10,
                ),
              );
            });
          },
          child: Text("改变 面板标题3的数据 为10"),
        ),
        TextButton(
          onPressed: () {
            widget.hide();
          },
          child: Text("收起面板"),
        ),
      ],
    );
  }
}
