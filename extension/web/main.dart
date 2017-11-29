import 'dart:html';
import 'dart:async';
import 'dart:convert';


final PANEL_HTML = """
<button>send</button>
""";


class AnnotatorAPI {

    static final String api_url = "http://localhost:8000/api/annotation/";
    final Map<String, String> headers;

    AnnotatorAPI(): headers = {
        "Content-Type": "application/json"
    };

    Future<bool> save(String url, String text) async {
        try {
            var response = await HttpRequest.request(
                    api_url,
                    method: "POST",
                    requestHeaders: headers,
                    sendData: JSON.encode({
                        'url': url,
                        'text': text
                    })
            );
            return response.status == 200 ? true : false;
        } catch(e) {
            return false;
        }
    }

}


class TrivePanel {
    AnnotatorAPI api = new AnnotatorAPI();

    DivElement panel = new DivElement()..id="trive-panel";

    TrivePanel() {
        panel.appendHtml(PANEL_HTML, treeSanitizer: NodeTreeSanitizer.trusted);
        document.body.insertBefore(panel, document.body.firstChild);
        panel.querySelector('button').onClick.listen(sendSelection);
        //addFromMeta('og:title');
        //addFromMeta('og:description');
        //addFromMeta('og:url');
    }

    sendSelection([_]) =>
            api.save(getFromMeta('og:url')??'http://trive.news', getSelection());

    String getFromMeta(String prop) {
        for (var meta in querySelectorAll('meta[property="${prop}"]')) {
            return meta.attributes['content'];
        }
    }

    String getSelection() {
        var sel = window.getSelection();
        var range = sel.getRangeAt(0);
        return range.toString();
    }

}


main() => new TrivePanel();
