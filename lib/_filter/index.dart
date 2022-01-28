import 'package:flutter/material.dart';
import 'package:flutter_dropdown_filter/_filter/widget/filter_empty_widget.dart';
import 'package:flutter_dropdown_filter/_filter/theme.dart';

import 'class.dart';
import 'actions.dart';
import 'framework.dart';

export 'widget/filter_empty_widget.dart';
export 'widget/filter_radio_list.dart';

/// S 筛选 对外提供
class Filter extends StatefulWidget {
  final Widget? child;
  final List<FilterItemWidget>? slot;
  final int? initialIndex;
  final FilterTheme? theme;
  final Function? onChange;
  final Function? onReset;
  final Function? onShow;
  final Function? onHide;
  final double? minHeight;
  final double? maxHeight;
  final List<Widget>? actions;
  final bool? isMask;
  final Color? maskColor;

  const Filter({
    Key? key,
    this.child,
    required this.slot,
    this.initialIndex,
    this.theme,
    this.onChange,
    this.onReset,
    this.onShow,
    this.onHide,
    this.maxHeight = 300,
    this.minHeight = 0,
    this.actions,
    this.isMask = true,
    this.maskColor,
  }) : super(key: key);

  @override
  FilterState createState() => FilterState();
}

class FilterState extends State<Filter> {
  final GlobalKey _containerKey = GlobalKey();

  /// 筛选的下标
  int? _selectIndex = null;

  /// 筛选布局的高度
  double selectHeight = 0;

  /// 面板列表 数据对应
  List<FilterItem> filterItem = [];
  List<GlobalKey<State>> filterItemPanelKey = [];
  List<GlobalKey<_FilterTitleWidgetState>> filterItemKey = [];

  @override
  void initState() {
    super.initState();

    late int _index = 0;

    // 生成key，以便通过key操作
    widget.slot!.forEach((i) {
      GlobalKey<_FilterTitleWidgetState> titleKey = GlobalKey();

      filterItemKey.add(titleKey);

      filterItem.add(
        FilterItem(
          name: _index.toString(),
          title: FilterTitleWidget(
            title: i.title,
            key: titleKey,
            index: _index++,
          )
            ..icon = i.icon!
            ..isIcon = i.isIcon!,
          panel: i.panel,
        ),
      );
    });

    filterItem.asMap().keys.forEach((index) {
      var element = filterItem[index];
      if (element.panel != null)
        element.panel!
          ..filterAll = filterItem
          ..show = show
          ..hide = hidden;
    });
  }

  @override
  didUpdateWidget(oldWidget) {
    // 初始展开的面板
    if (widget.initialIndex != null) {
      _selectIndex = widget.initialIndex;
      _onUpdateItemState(true, index: _selectIndex);
    }

    selectHeight = _containerKey.currentContext!.findRenderObject()!.semanticBounds.size.height;

    super.didUpdateWidget(oldWidget);
  }

  /// [Event]
  /// item.title 内部状态更新
  _onUpdateItemState(_is, {index = null}) {
    filterItemKey.forEach((key) {
      // 更新内部状态
      key.currentState!.widget.stateSetter_!(() {
        // 没有对应index（对象）, 则都收起状态
        if (index == null) {
          key.currentState!.showPanel = false;
          return;
        }

        key.currentState!.showPanel = !_is ? _is : index == key.currentState!.widget.index;
      });
    });
  }

  /// [Event]
  /// 重置面板
  _onRefreshSelect() {
    widget.onHide != null ? widget.onHide!() : null;

    setState(() {
      _selectIndex = null;
    });
  }

  /// [Event]
  /// 展开对应面板
  _onSelectChange(int index) {
    widget.onShow != null ? widget.onShow!() : null;

    if (_selectIndex == index) {
      _onUpdateItemState(false);
      _onRefreshSelect();
      return;
    }

    setState(() {
      _selectIndex = index;
    });

    _onUpdateItemState(true, index: index);
  }

  /// [Event]
  /// 获取结果
  void _getData() {
    List values = [];

    filterItem.forEach((element) {
      values.add(element.panel!.data!);
    });

    widget.onChange != null ? widget.onChange!(values) : null;
  }

  /// [Event]
  /// 展开
  show(String name) {
    // 内部的name未设置是index， 如果设置了应当使用内部的name
    filterItem.asMap().keys.forEach((index) {
      dynamic element = filterItem[index];
      if (element.name == name) {
        // 展开对应面板
        _onSelectChange(index);
      }
    });
  }

  /// [Event]
  /// 收起
  void hidden() {
    _onRefreshSelect();
    _onUpdateItemState(false);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Text(_selectIndex.toString()),
        Container(
          margin: EdgeInsets.only(top: selectHeight),
          child: widget.child!,
        ),
        // mask
        Visibility(
          visible: widget.isMask! && _selectIndex != null,
          child: Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: Colors.black.withOpacity(.2),
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ),
        // 筛选头
        Positioned(
          child: Builder(
            builder: (context) => Container(
              key: _containerKey,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              constraints: BoxConstraints(
                minHeight: selectHeight,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor.withOpacity(.9),
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).dividerColor,
                    width: 0.5,
                  ),
                ),
              ),
              child: Wrap(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: filterItem.asMap().keys.map<Widget>((index) {
                      FilterItem item = filterItem[index];
                      return GestureDetector(
                        child: item.title!,
                        onTap: () {
                          _onSelectChange(index);
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          top: 0,
          left: 0,
          right: 0,
        ),
        // 内容面板
        Visibility(
          visible: _selectIndex != null,
          child: Container(
            margin: EdgeInsets.only(top: selectHeight),
            constraints: BoxConstraints(
              maxHeight: widget.maxHeight!,
              minHeight: widget.minHeight!,
            ),
            child: Column(
              children: [
                // 内容卡槽
                Expanded(
                  child: Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: IndexedStack(
                      sizing: StackFit.passthrough,
                      index: _selectIndex,
                      children: filterItem.asMap().keys.map<Widget>((index) {
                        FilterItem item = filterItem[index];

                        if (item.panel == null)
                          item.panel = emptyFilter(
                            child: Container(),
                          );

                        return item.panel!;
                      }).toList(),
                    ),
                  ),
                  flex: 1,
                ),

                // 按钮组
                widget.actions == null
                    ? actionsFilterWidget(
                        onChange: () {
                          _getData();
                          hidden();
                        },
                        onReset: () {
                          widget.onReset!();
                        },
                      )
                    : Row(
                        children: widget.actions!,
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// E 筛选 对外提供

/// S 筛选标题 对外使用
class FilterItemWidget extends StatelessWidget {
  final Widget? title;
  final String? name;
  final FilterPanelWidget? panel;
  late FilterIcon? icon = FilterIcon();
  late bool? isIcon = true;

  FilterItemWidget({
    Key? key,
    this.title,
    this.name,
    this.panel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class FilterIcon {
  final IconData? up;
  final IconData? down;
  final Color? color;
  final Color? selectedColor;

  FilterIcon({
    this.up,
    this.down,
    this.color,
    this.selectedColor,
  });
}

/// E 筛选标题 对外使用

/// S 筛选标题 内部使用
class FilterTitleWidget extends StatefulWidget {
  // 标题
  final Widget? title;

  // 展存index
  final int? index;

  // 内部StateSetter
  StateSetter? stateSetter_;

  late FilterIcon icon;
  late bool isIcon;

  FilterTitleWidget({
    Key? key,
    this.title,
    this.index,
  }) : super(key: key);

  @override
  _FilterTitleWidgetState createState() => _FilterTitleWidgetState();
}

class _FilterTitleWidgetState extends State<FilterTitleWidget> {
  late bool showPanel = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Container(
          child: widget.title,
          margin: const EdgeInsets.only(right: 5),
        ),
        widget.isIcon
            ? StatefulBuilder(
                builder: (BuildContext context, StateSetter stateSetter) {
                  widget.stateSetter_ = stateSetter;
                  IconData? up = Icons.arrow_drop_up;
                  IconData? down = Icons.arrow_drop_down;

                  if (widget.icon.up != null) up = widget.icon.up;
                  if (widget.icon.down != null) up = widget.icon.down;

                  return Container(
                    padding: const EdgeInsets.only(top: 2),
                    child: Icon(!showPanel ? up : down),
                  );
                },
              )
            : const ClipPath(),
      ],
    );
  }
}

/// E 筛选标题 内部使用
