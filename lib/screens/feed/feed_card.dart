import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:test_project/screens/feed/alert.dart';
import 'package:test_project/screens/feed/bloc/feed_model.dart';
import 'package:test_project/style/style.dart';

class FeedCard extends StatelessWidget {
  const FeedCard(
      {required this.createDuration,
      required this.userName,
      required this.caption,
      required this.interestTextList,
      required this.mediaList,
      required this.isAlert,
      super.key});
  final String createDuration;
  final String userName;
  final List<String> interestTextList;
  final String caption;
  final List<MediaModel> mediaList;
  final bool isAlert;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _UserInfo(createdDuration: createDuration, name: userName),
          Wrap(
              children: interestTextList
                  .map((e) => _InterestWidget(
                        interestText: e,
                      ))
                  .toList()),
          if (isAlert) const _AlertWidget(),
          _ExpandableText(text: caption),
          if (mediaList.isNotEmpty)
            SizedBox(
                height: 400,
                width: double.infinity,
                child: _ImageWidget(mediaList: mediaList)),
        ],
      ),
    );
  }
}

class _AlertWidget extends StatelessWidget with ActionAlertStateLessAddition {
  const _AlertWidget();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onTapAlert(context),
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
            color: Color.fromRGBO(241, 215, 215, 1),
            borderRadius: BorderRadius.all(Radius.circular(9))),
        padding: const EdgeInsets.all(12),
        child: const Text(
          'Alert',
          style: TextStyle(
              fontWeight: FontWeight.w400,
              color: Color.fromRGBO(205, 113, 111, 1),
              fontSize: 14),
        ),
      ),
    );
  }

  void _onTapAlert(BuildContext context) {
    showReportAlert(context, () => _onTapYes(context));
  }

  void _onTapYes(BuildContext context) {
    Navigator.of(context).pop();
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    Future.delayed(const Duration(seconds: 2)).then((value) {
      Navigator.of(context).pop();
      showDialog(
          context: context,
          builder: (context) {
            return const Align(
                alignment: Alignment.center, child: SuccessAlert());
          });
    });
  }
}

class _ImageWidget extends StatelessWidget {
  const _ImageWidget({required this.mediaList});
  final List<MediaModel> mediaList;
  @override
  Widget build(BuildContext context) {
    return PageView.builder(
        itemCount: mediaList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => Stack(
              alignment: Alignment.center,
              children: [
                Image.network(
                  mediaList[index].asset,
                ),
                if (mediaList[index].isVideo)
                  SvgPicture.asset('assets/images/play_icon.svg'),
              ],
            ));
  }
}

class _UserInfo extends StatelessWidget {
  const _UserInfo({required this.createdDuration, required this.name});
  final String name;
  final String createdDuration;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset('assets/images/avatar.png'),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color.fromRGBO(0, 37, 97, 1)),
                  ),
                ),
                Text(
                  createdDuration,
                  style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: greyColor),
                )
              ],
            ),
          ),
        ),
        SvgPicture.asset('assets/images/more.svg')
      ],
    );
  }
}

class _InterestWidget extends StatelessWidget {
  const _InterestWidget({required this.interestText});
  final String interestText;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
          color: Color.fromRGBO(238, 238, 238, 1),
          borderRadius: BorderRadius.all(Radius.circular(9))),
      padding: const EdgeInsets.all(12),
      child: Text(
        interestText,
        style: const TextStyle(
            fontWeight: FontWeight.w400,
            color: Color.fromRGBO(103, 103, 103, 1),
            fontSize: 14),
      ),
    );
  }
}

class _ExpandableText extends StatefulWidget {
  const _ExpandableText({required this.text});

  final String text;

  @override
  ExpandableTextState createState() => ExpandableTextState();
}

class ExpandableTextState extends State<_ExpandableText> {
  bool _readMore = true;
  void _onTapLink() {
    setState(() => _readMore = !_readMore);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double maxWidth = constraints.maxWidth;
        final text = TextSpan(
          text: widget.text,
        );
        final link = TextSpan(
            text: _readMore ? " ... More" : " Close",
            style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Color.fromRGBO(0, 37, 97, 1)),
            recognizer: TapGestureRecognizer()..onTap = _onTapLink);
        TextPainter textPainter = TextPainter(
          text: link,
          textDirection: TextDirection.rtl,
          maxLines: 2,
          ellipsis: '...',
        );
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final linkSize = textPainter.size;
        textPainter.text = text;
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final textSize = textPainter.size;

        final pos = textPainter.getPositionForOffset(Offset(
          textSize.width - linkSize.width,
          textSize.height,
        ));

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: RichText(
            softWrap: true,
            overflow: TextOverflow.clip,
            text: textPainter.didExceedMaxLines
                ? TextSpan(
                    text: _readMore
                        ? widget.text.substring(
                            0, textPainter.getOffsetBefore(pos.offset) ?? 0)
                        : widget.text,
                    style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Color.fromRGBO(0, 37, 97, 1)),
                    children: [link],
                  )
                : TextSpan(
                    text: widget.text,
                  ),
          ),
        );
      },
    );
  }
}
