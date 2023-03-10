import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:play_sound_app/player_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(title: 'Option 1'),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final FileType _pickingType = FileType.custom;
  late final PlayerLocalProvider _playerProvider;
  String? _fileName;
  String? _filePath;
  bool _isLoading = false;
  bool _isPlaying = false;
  double _volumeValue = 0.5;

  @override
  void initState() {
    super.initState();
    _playerProvider = PlayerLocalProvider();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _pickFile,
                  child: const Text('Pick the sound from Files'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(_fileName ?? ''),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (_filePath != null) {
                      _isPlaying ? _pauseSound() : _playSound(_filePath!);
                    } else {
                      _logException('You need to choose the sound!');
                    }
                  },
                  icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                  label: Text(_isPlaying ? 'Pause' : 'Play'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (_fileName == null) {
                      _logException('You don\'t have any playing sound.');
                      return;
                    }
                    _stopSoundAndResetData();
                  },
                  icon: const Icon(Icons.stop),
                  label: const Text('Stop and remove sound'),
                ),
              ),
              if (_fileName != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Slider(
                    value: _volumeValue,
                    min: 0,
                    max: 1,
                    divisions: 100,
                    onChanged: (value) {
                      _playerProvider.setVolume(value);
                      setState(() {
                        _volumeValue = value;
                      });
                    },
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  void _pickFile() async {
    try {
      var result = await FilePicker.platform.pickFiles(
        type: _pickingType,
        allowMultiple: false,
        onFileLoading: (FilePickerStatus status) => print(status),
        allowedExtensions: ['mp3', 'wav'],
      );

      if (result == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      _stopSoundAndResetData();
      _filePath = result.files.single.path;
      _fileName = result.files.single.name;

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    } on PlatformException catch (e) {
      _logException('Unsupported operation $e');
    } catch (e) {
      _logException(e.toString());
    }
  }

  void _logException(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _pauseSound() {
    try {
      _playerProvider.pauseSound();
      setState(() {
        _isPlaying = false;
      });
    } on PlatformException catch (_) {
      return;
    }
  }

  void _playSound(String soundUrl) {
    try {
      _playerProvider.playSound(soundUrl);
      setState(() {
        _isPlaying = true;
      });
    } on PlatformException catch (_) {
      return;
    }
  }

  void _stopSoundAndResetData() {
    _playerProvider.stopSound();
    setState(() {
      _isPlaying = false;
      _fileName = null;
      _filePath = null;
    });
  }
}
