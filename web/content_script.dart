import 'dart:html';
import 'package:chrome/chrome_ext.dart' as chrome;
import 'package:angular/angular.dart';
import 'package:trive_extension/components.dart';

main() {
    var body = querySelector('body');
    if (body != null) {
        body.appendHtml('<trive-panel></trive-panel>', treeSanitizer: NodeTreeSanitizer.trusted);
        bootstrap(TrivePanel, [provide(chrome.ChromeRuntime, useValue: chrome.runtime)]);
    }
}
