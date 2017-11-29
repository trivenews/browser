import 'dart:html';

final html = """

""";

class TrivePanel {
    DivElement panel = new DivElement()..id="trive-panel";

    TrivePanel() {
        panel.appendHtml(html, treeSanitizer: NodeTreeSanitizer.trusted);
        document.body.insertBefore(panel, document.body.firstChild);
        addFromMeta('og:title');
        //addFromMeta('og:description');
    }

    addFromMeta(String prop) {
        for (var meta in querySelectorAll('meta[property="${prop}"]')) {
            var content = meta.attributes['content'];
            break;
        }
    }

}


main() => new TrivePanel();
