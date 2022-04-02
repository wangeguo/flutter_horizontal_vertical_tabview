library flutter_horizontal_vertical_tabview;

import 'package:flutter/material.dart';

/// A horizontal tab widget for flutter
class HorizontalTabView extends StatefulWidget {
  final int initialIndex;
  final List<Tab> tabs;
  final List<Widget> contents;
  final bool disabledChangePageFromContentView;
  final Axis contentScrollAxis;
  final Duration changePageDuration;
  final Curve changePageCurve;
  final Function(int tabIndex)? onSelect;
  final Color? backgroundColor;

  const HorizontalTabView(
      {Key? key,
      required this.tabs,
      required this.contents,
      this.initialIndex = 0,
      this.disabledChangePageFromContentView = false,
      this.contentScrollAxis = Axis.vertical,
      this.changePageCurve = Curves.easeInOut,
      this.changePageDuration = const Duration(milliseconds: 300),
      this.onSelect,
      this.backgroundColor})
      : super(key: key);

  @override
  _HorizontalTabViewState createState() => _HorizontalTabViewState();
}

class _HorizontalTabViewState extends State<HorizontalTabView>
    with TickerProviderStateMixin {
  late int _selectedIndex;
  late bool _changePageByTapView;

  late Animation<double> animation;
  late Animation<RelativeRect> rectAnimation;

  late TabController controller;
  PageController pageController = PageController();

  List<AnimationController> animationControllers = [];

  ScrollPhysics pageScrollPhysics = const AlwaysScrollableScrollPhysics();

  @override
  void initState() {
    _selectedIndex = widget.initialIndex;
    _changePageByTapView = false;

    controller = TabController(
        length: widget.tabs.length,
        vsync: this,
        initialIndex: widget.initialIndex);

    for (int i = 0; i < widget.tabs.length; i++) {
      animationControllers.add(AnimationController(
        duration: const Duration(milliseconds: 400),
        vsync: this,
      ));
    }
//    _selectTab(widget.initialIndex);

    if (widget.disabledChangePageFromContentView == true) {
      pageScrollPhysics = const NeverScrollableScrollPhysics();
    }

    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      pageController.jumpToPage(widget.initialIndex);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.backgroundColor ?? Theme.of(context).canvasColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(children: [
            const Icon(Icons.arrow_left, color: Colors.grey),
            Expanded(
              child: TabBar(
                isScrollable: true,
                controller: controller,
                labelColor: Theme.of(context).primaryColor,
                unselectedLabelColor: Theme.of(context).hintColor,
                indicator: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 2,
                    ),
                  ),
                ),
                tabs: widget.tabs,
                onTap: (index) {
                  _changePageByTapView = true;
                  setState(() {
                    _selectTab(index);
                  });

                  pageController.animateToPage(index,
                      duration: widget.changePageDuration,
                      curve: widget.changePageCurve);
                },
              ),
            ),
            const Icon(Icons.arrow_right, color: Colors.grey),
          ]),
          Expanded(
            child: PageView.builder(
              scrollDirection: widget.contentScrollAxis,
              physics: pageScrollPhysics,
              onPageChanged: (index) {
                if (_changePageByTapView == false) {
                  _selectTab(index);
                }
                if (_selectedIndex == index) {
                  _changePageByTapView = false;
                }

                setState(() {});
              },
              controller: pageController,
              itemCount: widget.contents.length,
              itemBuilder: (BuildContext context, int index) {
                return widget.contents[index];
              },
            ),
          ),
        ],
      ),
    );
  }

  void _selectTab(index) {
    if (index == -1) return;

    _selectedIndex = index;
    for (AnimationController animationController in animationControllers) {
      animationController.reset();
    }
    animationControllers[index].forward();
    controller.animateTo(_selectedIndex);

    if (widget.onSelect != null) {
      widget.onSelect!(_selectedIndex);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    pageController.dispose();
    for (AnimationController animationController in animationControllers) {
      animationController.dispose();
    }
    super.dispose();
  }
}
