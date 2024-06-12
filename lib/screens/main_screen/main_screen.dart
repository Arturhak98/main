import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:test_project/screens/condition/conditon_screen.dart';
import 'package:test_project/screens/feed/feed_screen.dart';
import 'package:test_project/settings/settings_screen.dart';
import 'package:test_project/style/style.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: BottomNavigationBar(),
    );
  }
}

class BottomNavigationBar extends StatefulWidget {
  const BottomNavigationBar({super.key});
  @override
  State<BottomNavigationBar> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<BottomNavigationBar>
    with TickerProviderStateMixin {
  late final _tabController =
      TabController(length: NavigationBarType.values.length, vsync: this);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: TabBarView(
          dragStartBehavior: DragStartBehavior.down,
          controller: _tabController,
          children: const [ConditonScreen(), FeedScreen(), SettingScreen()],
        ),
        bottomNavigationBar: ValueListenableBuilder(
            valueListenable:
                _tabController.animation ?? ValueNotifier<double>(0),
            builder: (context, offset, widget) {
              return Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    height: 100,
                    color: white,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: NavigationBarType.values
                        .map((e) => _NavigationBarItem(
                              currentType: e,
                              selcetedType:
                                  NavigationBarType.values[offset.round()],
                              onItemSelect: _onItemSelect,
                            ))
                        .toList(),
                  ),
                ],
              );
            }));
  }

  void _onItemSelect(NavigationBarType selectedType) {
    _tabController.animateTo(NavigationBarType.values.indexOf(selectedType));
  }
}

class _NavigationBarItem extends StatelessWidget {
  const _NavigationBarItem({
    required this.currentType,
    required this.selcetedType,
    required this.onItemSelect,
  });
  final NavigationBarType currentType;
  final NavigationBarType selcetedType;
  final Function(NavigationBarType) onItemSelect;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SafeArea(
        child: GestureDetector(
          onTap: () => onItemSelect.call(currentType),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                  '${currentType.iconAsset()}${selcetedType == currentType ? '_selected.svg' : '.svg'}'),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(currentType.title(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                        color: selcetedType == currentType
                            ? blueColor
                            : greyColor)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum NavigationBarType { conditions, feed, setting }

extension NavigationBarTypeExtension on NavigationBarType {
  String iconAsset() {
    switch (this) {
      case NavigationBarType.conditions:
        return 'assets/images/condition_icon';
      case NavigationBarType.feed:
        return 'assets/images/feed_icon';
      case NavigationBarType.setting:
        return 'assets/images/setting_icon';
    }
  }

  String title() {
    switch (this) {
      case NavigationBarType.conditions:
        return 'Conditions';
      case NavigationBarType.feed:
        return 'Feed';
      case NavigationBarType.setting:
        return 'Settings';
    }
  }
}
