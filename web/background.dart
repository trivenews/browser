import 'package:chrome/chrome_ext.dart' as chrome;
import 'package:trive_extension/extension.dart';

main() =>
    new TriveChromeExtension(chrome.runtime, new Session())
        ..setupBrowser()
        ..setupCookies();
