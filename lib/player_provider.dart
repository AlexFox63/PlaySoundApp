import 'package:play_sound_app/method_channel.dart';

const String _methodChannelName = 'com.example.playSoundApp/method';
const String _invokePlaySoundMethod = 'play';
const String _invokeStopSoundMethod = 'stop';
const String _invokePauseSoundMethod = 'pause';
const String _invokeSetVolumeMethod = 'setVolume';

class PlayerLocalProvider {
  late final ChannelWrapper methodChannel;

  PlayerLocalProvider() : methodChannel = ChannelWrapper(_methodChannelName);

  Future<void> playSound(String soundUrl) async {
    await methodChannel.invokeMethod(
      invokeMethodName: _invokePlaySoundMethod,
      args: {'url': soundUrl},
    );
  }

  Future<void> stopSound() async {
    await methodChannel.invokeMethod(invokeMethodName: _invokeStopSoundMethod);
  }

  Future<void> pauseSound() async {
    await methodChannel.invokeMethod(invokeMethodName: _invokePauseSoundMethod);
  }

  Future<void> setVolume(double value) async {
    await methodChannel
        .invokeMethod(invokeMethodName: _invokeSetVolumeMethod, args: {'volumeValue': value});
  }
}
