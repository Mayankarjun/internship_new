import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';

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
  final List<String> textPaths = [
    'assets/Text/simple.txt',
    'assets/Text/simple2.txt',
    'assets/Text/simple3.txt',
  ];

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView.builder(
        itemCount: textPaths.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                FutureBuilder<String>(
                  future: _loadTextAsset(textPaths[index]),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error loading text: ${snapshot.error}'));
                    } else {
                      List<String> lines = (snapshot.data ?? '').split('\n');
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: lines.map((line) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(line),
                          );
                        }).toList(),
                      );
                    }
                  },
                ),
                SizedBox(height: 20),
                IconButton(
                  icon: Icon(Icons.share),
                  onPressed: () {
                    Share.share('Check out this text post: [your_dynamic_link_here]');
                  },
                ),
                SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<String> _loadTextAsset(String path) async {
    return await rootBundle.loadString(path);
  }
}

class VideoPost extends StatelessWidget {
  final List<String> videoPaths = [
    'assets/videos/Welcome.mp4',
    'assets/videos/intro.mp4',
    'assets/videos/Outro.mp4',
  ];

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView.builder(
        itemCount: videoPaths.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                Container(
                  width: 400,
                  height: 300,
                  child: VideoPlayerWidget(assetPath: videoPaths[index]),
                ),
                SizedBox(height: 20),
                IconButton(
                  icon: Icon(Icons.share),
                  onPressed: () {
                    Share.share('Check out this video post: [your_dynamic_link_here]');
                  },
                ),
                SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ImagePost extends StatelessWidget {
  final List<String> imagePaths = [
    'assets/images/running_shoe.png',
    'assets/images/image.png',
    'assets/images/image3.png',
    'assets/images/image4.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView.builder(
        itemCount: imagePaths.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                Image.asset(imagePaths[index]),
                SizedBox(height: 20),
                IconButton(
                  icon: Icon(Icons.share),
                  onPressed: () {
                    Share.share('Check out this image post: [your_dynamic_link_here]');
                  },
                ),
                SizedBox(height: 20),
              ],
            ),
          );
        },
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
  late VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.assetPath)
      ..initialize().then((_) {
        setState(() {}); // Ensure the first frame is shown after the video is initialized
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _isPlaying = false;
      } else {
        _controller.play();
        _isPlaying = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _controller.value.isInitialized
            ? AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        )
            : Center(child: CircularProgressIndicator()),
        IconButton(
          icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
          onPressed: _togglePlayPause,
        ),
      ],
    );
  }
}
