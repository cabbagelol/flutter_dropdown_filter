# flutter_dropdown_filter

下拉筛选控件😁, 重复性轮子，如何喜欢这样用法请⭐️。

特性

1. 可扩展筛选面板
2. 主题跟随Theme
3. 自由获取其他面板数据以及状态

待完成
[] 动画

## 1 使用

### 1.1 快速使用

`flutter_dropdown_filter`名字太长，本文以下统称 `筛选控件`，要使用 `筛选控件`需导入必要包。

```dart
import "../_filter/index.dart";
```

为您的widget上创建 `筛选控件`，字段 `slot`内使用 `FilterItemWidget`放置在插槽内。

```flutter
/// 例子1
Filter(
    slot: <FilterItemWidget>[
        FilterItemWidget(
            title: Text("面板标题1"),
            panel: emptyFilter(
              child: Text("面板内容1"),
            ),
        )
    ]
);

/// 例子2
/// 单选列表
FilterItemWidget(
    title: Text("面板标题1"),
    panel: radioListFilter.builder(
      itemCount: 100,
      itemBuilder: (content, index, selfindex) {
        return Text(index.toString());
      },
    ),
),
```

简易的 `筛选控件`完成，当然可以使用预设模板丰富内容。panel这里 `筛选控件`提供预设模板(emptyFilter, radioListFilter)，如果面板更加复杂，可以继承 `FilterPanelWidget`类。

1. emptyFilter 空白的panel面板
2. radioListFilter 单选列表面板

### 1.2 FilterPanelWidget

复杂的面板逻辑，可以继承FilterPanelWidget来绘制。

```flutter
class emptyFilter extends FilterPanelWidget {
  final Widget? child;

  emptyFilter({Key? key,
    this.child,
  }) : super(key: key);

  @override
  _emptyFilterState createState() => _emptyFilterState();
}

class _emptyFilterState extends State<emptyFilter> {
  @override
  build(BuildContext context) {
    return widget.child!;
  }
}
```

### 1.3 扩展第三方包
这里使用`syncfusion_flutter_datepicker`来演示，syncfusion_flutter_datepicker是一款日历包，提供精美的ui。

由于第三方往往诸多不确定，除了FilterPanelWidget继承完成，可以使用`emptyFilter`来包裹管理，这样`筛选控件`和其他面板一样收到可控。

```
// 1 创建变量来管理
FilterPanelWidget? dateWidget = emptyFilter();

// 2 初始widget
@override
void initState() {
    super.initState();
    initDateFilter();
}

initDateFilter() {
    dateWidget = emptyFilter(
      child: Container(
        child: SfDateRangePicker(
        
          // 这里提供了事件，这样便可以通过事件的回调改变emptyFilter内部的值
          onSelectionChanged: onSelectionChanged,
          view: DateRangePickerView.month,
          monthViewSettings: DateRangePickerMonthViewSettings(firstDayOfWeek: 1),
        ),
        margin: EdgeInsets.only(bottom: 20),
      ),
    );
}

onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    // 访问内部的data管理，并赋予它新值
    dateWidget!..data!.value = args.value;
}

// 3. 创建widget 与 获取
FilterItemWidget(
    title: Text("日历选择器"),
    panel: dateWidget,
    onChange: (data) {
        // 但筛选收到数据更改，此时既可捕捉变动 :D
    }
),

```

## 2 其他

### 2.1 事件

```
/// 使用方法例子
    Filter(
        key: _filterKey
        slot: <FilterItemWidget>[],
        onShow: () {
            // TODO 1
        }
    );
  
    _filterKey.onShow(() {
        // TODO 2
    });
```

1. onCh
2. onShow 筛选展开通知事件
3. onHide 筛选隐藏通知事件
4. onR 重置事件
5. show() 主动展开筛选
6. hide() 主动收起筛选

### 2.2 获取筛选结果

```
Filter(
    key: _filterKey
    slot: <FilterItemWidget>[],
    onChange: (data) {
    
    }
);

```

`筛选控件`的结果，可以在Filter内的`onChange`回调事件中取得，它的类型是`FilterPanelData`。

## 组件

### Filter 主体

| 字段           | 必要  | 类型               | 说明           | 版本 |
|--------------|-----|------------------|--------------| ---- |
| key          |     | Key              |              | 0.1  |
| slot         | *   | FilterItemWidget | 下拉筛选插槽       |      |
| onShow       |     | Function         | 显示回调         |      |
| onHide       |     | Function         | 隐藏回调         |      |
| onChange     |     | Function         | 数据变动时回调      |      |
| onReset      |     | Function         | 重置回调         |      |
| initialIndex |     | int              | 初始展开面板的index |      |
| child        |     | Widget           | 内容           |      |
| maxHeight    |     | double              | 最大高度         |      |
| minHeight    |     |   double               | 最小高度         |      |
| isMask       |     | bool             | 是否可见遮罩       |      |
| maskColor    |     | Color            | 遮罩颜色         |      |


| 字段    | 参数            | 类型                | 说明                                     | 版本 |
|-------|---------------|-------------------|----------------------------------------| ---- |
| show  | (String name) | void              | 展开对应面板                                 | 0.1  |
| hidden  |               | void              | 隐藏面板                                   |      |

### FilterItemWidget 筛选插槽的物体

管理筛选标题的widget与面板的widget练习。

| 字段    | 必要  | 类型                | 说明                                     | 版本 |
|-------|-----|-------------------|----------------------------------------| ---- |
| key   |     | Key               |                                        | 0.1  |
| title | *   | Widget            | 下拉筛选插槽                                 |      |
| panel |     | FilterPanelWidget | 面板内容                                   |      |
| name  |     | String            | 物体name，向show(name)方法条件取自这里，如果不填那么应当是下标 |      |

### FilterPanelWidget 抽象类

| 字段    | 必要  | 类型                       | 说明     | 版本 |
|-------|-----|--------------------------|--------| ---- |
| data  |     | FilterPanelData          | 面板数据   | 0.1  |
| getPanelData |     | void | 取得其他面板的FilterPanelData数据 |      |
