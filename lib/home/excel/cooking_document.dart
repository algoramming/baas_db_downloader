import 'dart:async';
import 'dart:math';

import 'package:baas_db_downloader/home/excel/animated_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';


Future<void> showCookingPopup(BuildContext context) async => await showDialog(
  context: context,
  barrierDismissible: false,
  builder: (_) => CookingDocumentPopup(),
);

class CookingDocumentPopup extends StatelessWidget {
  const CookingDocumentPopup({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return AnimatedPopup(
      child: AlertDialog(
        content: SizedBox(
          width: min(350, size.width),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset('assets/lottie/downloading.json', height: 200, fit: BoxFit.cover),
              const SizedBox(height: 16),
              Text(
                'Your document is cooking. Please don\'t close the app. It may take a while. Please wait...',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              ElevatedButton.icon(
                onPressed: null,
                label: Row(
                  children: [
                    const Icon(Icons.timer),
                    Expanded(child: TimerLoader()),
                    const Icon(Icons.timer),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


String _formatDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final hours = twoDigits(duration.inHours);
  final minutes = twoDigits(duration.inMinutes.remainder(60));
  final seconds = twoDigits(duration.inSeconds.remainder(60));
  return '$hours:$minutes:$seconds';
}

class TimerLoader extends StatefulWidget {
  const TimerLoader({super.key, this.color, this.onFinished});

  final Color? color;
  final void Function(Duration?)? onFinished;

  @override
  State<TimerLoader> createState() => _TimerLoaderState();
}

class _TimerLoaderState extends State<TimerLoader> {
  late Timer _timer;
  Duration _duration = const Duration();

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _duration += const Duration(seconds: 1);
      });
    });
  }

  @override
  void dispose() {
    widget.onFinished?.call(_duration);
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10.0,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SpinKitThreeBounce(color: widget.color ?? Theme.of(context).primaryColor, size: 15.0),
        Text(
          _formatDuration(_duration),
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: widget.color ?? Theme.of(context).primaryColor),
        ),
        SpinKitThreeBounce(color: widget.color ?? Theme.of(context).primaryColor, size: 15.0),
      ],
    );
  }
}

class TotalTimeDialog extends StatelessWidget {
  const TotalTimeDialog(this.duration, this.title, {super.key});

  final Duration duration;
  final String title;

  @override
  Widget build(BuildContext context) {
    return AnimatedPopup(
      child: AlertDialog(
        content: Column(
          spacing: 16.0,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineMedium),
            Text(_formatDuration(duration), style: Theme.of(context).textTheme.titleMedium),
            ElevatedButton(
              style: ElevatedButton.styleFrom(fixedSize: const Size(200, 42.0)),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}
