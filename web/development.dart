import 'dart:html';
import 'dart:async';
import 'dart:js';
import 'package:chrome/chrome_ext.dart' as chrome;
import 'package:angular/angular.dart';
import 'package:trive_extension/components.dart' show TrivePanel;
import 'package:trive_extension/extension.dart' show TriveChromeExtension, Session;


class Port implements chrome.Port {

    String name;
    chrome.MessageSender sender;
    Port other;

    StreamController _onDisconnect = new StreamController();
    get onDisconnect => _onDisconnect.stream;

    StreamController _onMessage = new StreamController();
    get onMessage => _onMessage.stream;

    Port(this.name) {}

    void disconnect([var arg1]) {
        other._onDisconnect.add(arg1);
    }

    void postMessage([var arg1]) {
        other._onMessage.add(new chrome.OnMessageEvent(arg1, sender, null));
    }

    toJs() => new JsObject.jsify({'name': this.name});
    get jsProxy => null;

}


class DevelopmentRuntime implements chrome.ChromeRuntime {

    StreamController _onInstalled = new StreamController();
    get onInstalled => _onInstalled.stream;

    StreamController _onUpdateAvailable = new StreamController();
    get onUpdateAvailable => _onUpdateAvailable.stream;

    StreamController _onBrowserUpdateAvailable = new StreamController();
    get onBrowserUpdateAvailable => _onBrowserUpdateAvailable.stream;

    StreamController _onStartup = new StreamController();
    get onStartup => _onStartup.stream;

    StreamController _onSuspend = new StreamController();
    get onSuspend => _onSuspend.stream;

    StreamController _onSuspendCanceled = new StreamController();
    get onSuspendCanceled => _onSuspendCanceled.stream;

    StreamController _onConnect = new StreamController();
    get onConnect => _onConnect.stream;

    StreamController _onConnectExternal = new StreamController();
    get onConnectExternal => _onConnectExternal.stream;

    StreamController _onMessage = new StreamController();
    get onMessage => _onMessage.stream;

    StreamController _onMessageExternal = new StreamController();
    get onMessageExternal => _onMessageExternal.stream;

    StreamController _onRestartRequired = new StreamController();
    get onRestartRequired => _onRestartRequired.stream;

    StreamController _onRestartRequiredReason = new StreamController();
    get onRestartRequiredReason => _onRestartRequiredReason.stream;

    bool get available => true;

    chrome.LastErrorRuntime get lastError => null;

    String get id => 'id';

    Future<chrome.Window> getBackgroundPage() {}

    Future openOptionsPage() {}

    Map<String, dynamic> getManifest() {}

    String getURL(String path) {}

    Future setUninstallURL(String url) {}

    void reload() {}

    Future<chrome.RequestUpdateCheckResult> requestUpdateCheck() {}

    void restart() {}

    Future restartAfterDelay(int seconds) {}

    chrome.Port connectNative(String application) {}

    Future<dynamic> sendMessage(dynamic message, [String extensionId, chrome.RuntimeSendMessageParams options]) {}

    Future<dynamic> sendNativeMessage(String application, Map<String, dynamic> message) {}

    Future<chrome.PlatformInfo> getPlatformInfo() {}

    Future<DirectoryEntry> getPackageDirectoryEntry() {}

    DevelopmentRuntime() {
    }

    Port connect([String extensionId, chrome.RuntimeConnectParams connectInfo]) {
        var port1 = new Port(extensionId);
        var port2 = new Port(extensionId);
        port1.other = port2;
        port2.other = port1;
        _onConnect.add(port2);
        return port1;
    }
}


class DevSession extends Session {
    @override
    Map getCookies() {
        var result = {};
        var cookies = document.cookie != null ? document.cookie.split('; ') : [
        ];
        for (var cookie in cookies) {
            var parts = cookie.split('=');
            var name = Uri.decodeComponent(parts[0].replaceAll(r"\+", ' '));
            var value = Uri.decodeComponent(parts[1].replaceAll(r"\+", ' '));
            result[name] = value;
        }
        return result;
    }
}


main() {
    var dev_runtime = new DevelopmentRuntime();
    new TriveChromeExtension(dev_runtime, new DevSession());
    document.body.appendHtml('<trive-panel></trive-panel>', treeSanitizer: NodeTreeSanitizer.trusted);
    bootstrap(TrivePanel, [provide(chrome.ChromeRuntime, useValue: dev_runtime)]);
}
