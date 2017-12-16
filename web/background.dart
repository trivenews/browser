import 'package:chrome/chrome_ext.dart' as chrome;

main() {
    chrome.browserAction.onClicked.listen((tab) {
        chrome.tabs.executeScript(null, {file: "content_script.js"});
    });
}
