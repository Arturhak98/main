import 'package:flutter/material.dart';
import 'package:test_project/style/style.dart';

mixin ActionAlertStateLessAddition on StatelessWidget {
  void showReportAlert(BuildContext context, VoidCallback onTapYes) {
    print('alert');
    showDialog(
        context: context,
        builder: (context) {
          return Align(
              alignment: Alignment.center,
              child: ReportAlert(
                onTapYes: onTapYes,
              ));
        });
  }
}

class ReportAlert extends StatelessWidget {
  const ReportAlert({required this.onTapYes, super.key});
  final VoidCallback onTapYes;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(14), color: white),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Are you sure you want to report this post?'),
            AlertButton(
              onTap: onTapYes,
              text: 'Yes',
            ),
            AlertButton(text: 'go Back', onTap: () => _onCancel(context))
          ],
        ),
      ),
    );
  }

  void _onCancel(BuildContext context) {
    Navigator.of(context).pop();
  }
}

class SuccessAlert extends StatelessWidget {
  const SuccessAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14), color: white),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Are you sure you want to report this post?'),
              AlertButton(text: 'ok', onTap: () => _onCancel(context))
            ],
          ),
        ));
  }

  void _onCancel(BuildContext context) {
    Navigator.of(context).pop();
  }
}

class AlertButton extends StatelessWidget {
  const AlertButton({required this.text, required this.onTap, super.key});
  final VoidCallback onTap;
  final String text;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          margin: const EdgeInsets.all(15),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: const Color.fromRGBO(255, 109, 85, 1)),
          child: Text(text)),
    );
  }
}
