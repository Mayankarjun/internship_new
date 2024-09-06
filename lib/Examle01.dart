import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    TextPost(),
    VideoPost(),
    ImagePost(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Post Share App")),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.text_fields), label: 'Text'),
          BottomNavigationBarItem(icon: Icon(Icons.video_library), label: 'Video'),
          BottomNavigationBarItem(icon: Icon(Icons.image), label: 'Image'),
        ],
      ),
    );
  }
}

class TextPost extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _loadTextAsset('assets/Text/simple.txt'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error loading text'));
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(snapshot.data ?? 'No text available.'),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Share.share('Check out this text post: [your_dynamic_link_here]');
                  },
                  child: Text("Share"),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Future<String> _loadTextAsset(String path) async {
    return await rootBundle.loadString(path);
  }
}

class VideoPost extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 300,
            height: 200,
            child: VideoPlayerWidget(assetPath: "assets/videos/Welcome.mp4"),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Share.share('Check out this video post: [your_dynamic_link_here]');
            },
            child: Text("Share"),
          ),
        ],
      ),
    );
  }
}

class ImagePost extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/running_shoe.png'),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Share.share('Check out this image post: [your_dynamic_link_here]');
            },
            child: Text("Share"),
          ),
        ],
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String assetPath;

  VideoPlayerWidget({required this.assetPath});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: VideoPlayer(
        VideoPlayerController.asset(widget.assetPath)
          ..initialize().then((_) {
            setState(() {});
          })
          ..setLooping(true)
          ..play(),
      ),
    );
  }
}
