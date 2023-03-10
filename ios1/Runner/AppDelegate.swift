import UIKit
import Flutter


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    var methodChannel: FlutterMethodChannel?
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        configurePlayerChannels();
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}

extension AppDelegate {
    func configurePlayerChannels() {
        let controller : FlutterViewController = window.rootViewController as! FlutterViewController
        
        methodChannel = FlutterMethodChannel(name: "com.example.playSoundApp/method", binaryMessenger: controller.binaryMessenger)
        
        methodChannel?.setMethodCallHandler({
            [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
            if (call.method == "play")
            {
                if let args = call.arguments as? Dictionary<String, Any>,
                   let soundUrl = args["url"] as? String, !soundUrl.isEmpty {
                    playSoundFromUrl(url: soundUrl)
                }
            } else if (call.method == "stop") {
                stopSound()
            } else if (call.method == "pause") {
                pauseSound()
            } else if (call.method == "setVolume") {
                if let args = call.arguments as? Dictionary<String, Any>,
                   let volume = args["volumeValue"] as? Float {
                    setVolume(volume: volume)
                }
            }
            else {
                result(FlutterMethodNotImplemented)
                return
            }
        })
    }
}

