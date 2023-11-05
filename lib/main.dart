import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final player = Player(configuration: const PlayerConfiguration());
  late final VideoController controller = VideoController(player);

  StreamSubscription<String>? errorStream;
  @override
  void initState() {
    super.initState();

    errorStream = player.stream.error.listen((error) async {
      log(error, name: "Video Player");
    });

    playVideo();
  }

  Future<void> playVideo() async {
    if (player.platform is NativePlayer) {
      await (player.platform as dynamic).setProperty(
        'demuxer-lavf-o',
        'decryption_key=0123456789abcdef0123456789abcdef',
      );
    }

    await player.open(Media(
        'https://github.com/mhdkadi/video_player/blob/master/big_buck_bunny_480p_trailer.m4v'));
  }

  @override
  void dispose() {
    player.dispose();
    errorStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Video(controller: controller));
  }
}
