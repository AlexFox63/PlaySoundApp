package com.example.play_sound_app

import android.content.Context
import android.media.MediaPlayer
import android.net.Uri

var mMediaPlayer: MediaPlayer? = null

fun playSoundFromUrl(url: String, context: Context) {
    var soundUri = Uri.parse(url);
    if (mMediaPlayer == null) {
        mMediaPlayer = MediaPlayer.create(context, soundUri)
        mMediaPlayer!!.start()
    } else mMediaPlayer!!.start()
}

fun stopSound() {
    if (mMediaPlayer != null) {
        mMediaPlayer!!.stop()
        mMediaPlayer!!.release()
        mMediaPlayer = null
    }
}

fun pauseSound() {
    if (mMediaPlayer != null) {
        mMediaPlayer!!.pause()
    }
}

fun setVolume(volume: Double) {
    if (mMediaPlayer != null) {
        val maxVolume = 100.0
        val volumeValue = (1 - (Math.log((maxVolume - volume)) / Math.log(maxVolume)));
        mMediaPlayer!!.setVolume(volumeValue.toFloat(), volumeValue.toFloat())
    }
}

