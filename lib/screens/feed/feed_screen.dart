import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:test_project/data/repositories/api/feed_api.dart';
import 'package:test_project/screens/feed/bloc/feed_bloc.dart';
import 'package:test_project/screens/feed/feed_card.dart';
import 'package:test_project/style/style.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final _feedBloc = FeedBloc(feedApi: FeedApiImpl());
  @override
  void initState() {
    _feedBloc.add(InitEvent());
    super.initState();
  }

  void _loadMoreData() {
    _feedBloc.add(LoadItemsEvent(from: _feedBloc.state.state.length));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _feedBloc,
      child: BlocBuilder<FeedBloc, FeedState>(
        builder: (context, state) {
          return Scaffold(
              body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                const _TopBar(),
                Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (notification is ScrollEndNotification &&
                          notification.metrics.extentAfter < 500) {
                        _loadMoreData();
                      }
                      return false;
                    },
                    child: ListView.builder(
                        itemCount: state.state.length,
                        itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: FeedCard(
                                  isAlert: state.state[index].isAlert,
                                  createDuration:
                                      state.state[index].creatDuration,
                                  userName: state.state[index].user.userName,
                                  caption: state.state[index].caption,
                                  interestTextList:
                                      state.state[index].interests,
                                  mediaList: state.state[index].media),
                            )),
                  ),
                ),
              ]));
        },
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 87, left: 31, right: 22),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Text(
            'Insider Feed',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 17,
                color: Color.fromRGBO(0, 37, 97, 1)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const _TypeButton(),
              SvgPicture.asset('assets/images/filter_icon.svg')
            ],
          ),
        ],
      ),
    );
  }
}

class _TypeButton extends StatelessWidget {
  const _TypeButton();
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        constraints: const BoxConstraints.tightFor(width: 230),
        offset: const Offset(0, 28),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        itemBuilder: _popUpMenuBuilder,
        child: Row(
          children: [
            Text(
              ItemType.all.name,
              style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Color.fromRGBO(0, 37, 97, 1)),
            ),
          ],
        ));
  }

  List<PopupMenuEntry> _popUpMenuBuilder(BuildContext context) {
    return ItemType.values
        .map((itemType) {
          return <PopupMenuEntry>[
            CustomPopUpMenuItem(
              filterType: itemType,
              selectedItem: ItemType.all,
              onTap: (item) {},
            ),
          ];
        })
        .expand((element) => element)
        .toList();
  }
}

class CustomPopUpMenuItem extends PopupMenuEntry {
  const CustomPopUpMenuItem(
      {required this.filterType,
      required this.selectedItem,
      required this.onTap,
      super.key});
  final ItemType filterType;
  final ItemType selectedItem;
  final Function(ItemType) onTap;

  @override
  State<StatefulWidget> createState() => _PopUpMenuItemState(
      filterType: filterType, selectedItem: selectedItem, onTap: onTap);

  @override
  double get height => kMinInteractiveDimension;

  @override
  bool represents(value) => true;
}

class _PopUpMenuItemState extends State {
  _PopUpMenuItemState(
      {required this.filterType,
      required this.selectedItem,
      required this.onTap});
  final ItemType filterType;
  final ItemType selectedItem;
  final Function(ItemType) onTap;

  @override
  Widget build(BuildContext context) {
    return PopupMenuItem(
      padding: const EdgeInsets.only(
        left: 20,
        right: 15,
      ),
      onTap: onTap.call(filterType),
      child: SizedBox(
        height: 39,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: filterType == selectedItem
                  ? const Color.fromRGBO(69, 141, 190, 1)
                  : const Color.fromRGBO(246, 247, 248, 1)),
          child: Center(
            child: Text(
              filterType.name,
              style: TextStyle(
                color: filterType == selectedItem ? white : greyColor,
                fontSize: 16,
                fontWeight: filterType == selectedItem
                    ? FontWeight.w600
                    : FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum ItemType { all, interst }
