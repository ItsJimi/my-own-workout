import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wakelock/wakelock.dart';
import 'utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Wakelock.enable();
    return MaterialApp(
      title: 'My own workout',
      theme: ThemeData(
        primaryColor: Colors.black,
        colorScheme: ColorScheme.fromSwatch()
            .copyWith(primary: Colors.black, background: Colors.white),
      ),
      darkTheme: ThemeData(
        primaryColor: Colors.white,
        colorScheme: ColorScheme.fromSwatch()
            .copyWith(primary: Colors.white, background: Colors.black),
      ),
      themeMode: ThemeMode.system,
      home: const MyHomePage(title: 'My own workout'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String time = "00:00";
  bool _isRunning = false;
  final stopwatch = Stopwatch();

  @override
  void initState() {
    Timer.periodic(const Duration(milliseconds: 100), (Timer timer) {
      var minutes = stopwatch.elapsed.inMinutes;
      var seconds = (minutes > 0)
          ? stopwatch.elapsed.inSeconds - 60 * minutes
          : stopwatch.elapsed.inSeconds;
      setState(() {
        time = "${formatTime(minutes)}:${formatTime(seconds)}";
      });
    });
    super.initState();
  }

  void _toggleStopwatch() {
    stopwatch.isRunning ? stopwatch.stop() : stopwatch.start();
    setState(() {
      _isRunning = !_isRunning;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GestureDetector(
          onTap: () => stopwatch.reset(),
          child: Column(
            children: <Widget>[
              Expanded(
                  child: Container(
                      color: Theme.of(context).colorScheme.background,
                      child: Center(
                        child: Text(
                          time,
                          style: TextStyle(
                              fontSize: 100,
                              color: Theme.of(context).colorScheme.primary),
                        ),
                      ))),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.background,
          onPressed: _toggleStopwatch,
          tooltip: _isRunning ? 'Stop' : 'Start',
          child: _isRunning
              ? const Icon(Icons.stop_rounded)
              : const Icon(Icons
                  .play_arrow_rounded), // This trailing comma makes auto-formatting nicer for build methods.
        ));
  }
}
