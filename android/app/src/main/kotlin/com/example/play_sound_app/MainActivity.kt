package com.example.play_sound_app

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.playSoundApp/method"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            if (call.method == "play") {
                val args = call.arguments as? Map<*, *>
                val soundUrl = args!!["url"] as? String
                if (soundUrl != null && soundUrl.isNotEmpty()) {
                    playSoundFromUrl(soundUrl, applicationContext)
                }
            } else if (call.method == "stop") {
                stopSound()
            } else if (call.method == "pause") {
                pauseSound()
            } else if (call.method == "setVolume") {
                val args = call.arguments as? Map<*, *>
                val volume = args!!["volumeValue"] as? Double
                if (volume != null) {
                    setVolume(volume)
                }
            } else {
                result.notImplemented()
            }
        }
    }
}
