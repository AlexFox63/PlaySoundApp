import 'dart:developer';

import 'package:flutter/services.dart';

class ChannelWrapper {
  ChannelWrapper(this.methodChannelName) {
    if (methodChannelName != null) methodChannel = MethodChannel(methodChannelName!);
  }

  late MethodChannel? methodChannel;
  final String? methodChannelName;

  Future<Object?> invokeMethod({
    required String invokeMethodName,
    Map<String, Object?>? args,
  }) async {
    try {
      var methodChannel = this.methodChannel;
      if (methodChannel != null) {
        return methodChannel.invokeMethod(invokeMethodName, args);
      }
    } on PlatformException catch (e) {
      log(e.message ?? 'Unsupported exception');
    }
    return null;
  }
}
