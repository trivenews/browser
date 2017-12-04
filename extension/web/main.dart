import 'dart:html';
import 'dart:async';
import 'dart:convert';
import 'package:annotator/annotator.dart';


class API {

    static final String api_url = "http://localhost:8000/api/";
    static final Map<String, String> headers = {
        "Content-Type": "application/json"
    };

    static Future<bool> save(Model model) async {
        try {
            var response = await HttpRequest.request(
                    "${api_url}/${model.type}/",
                    method: "POST",
                    requestHeaders: headers,
                    sendData: model.json
            );
            return response.status == 200 ? true : false;
        } catch(e) {
            return false;
        }
    }

}


abstract class Model {
    String get type;
    Map get map;
    String get json => JSON.encode(map);
}


class Author extends Model {
    final type = 'author';

    String name;
    String twitter;
    String facebook;

    Map get map => {
        'name': name,
        'twitter': twitter,
        'facebook': facebook,
    };
}


class Article extends Model {
    final type = 'article';

    String url;
    String title;
    String image;
    String description;
    List<Author> authors;
    String publisher;

    Map get map => {
        'url': url,
        'title': title,
        'image': image,
        'description': description,
        'publisher': publisher,
        'authors': authors.map((a)=>a.json)
    };
}


class Claim extends Model {
    final type = 'claim';

    Article article;

    String statement;
    String selector;
    int start, length;
    String research;
    int truth;
    List<String> sources;

    Map get map => {
        'statement': statement,
        'selector': selector,
        'offset': start,
        'length': length,
        'research': research,
        'truth': truth,
        'sources': sources
    };

}


class ClaimEditor {

    static final String HTML = """
        <span></span>
        <textarea></textarea>
        <button id='save-trive-claim'>Save</button>
        <button id='delete-trive-claim'>Delete</button>
    """;

    Claim claim;

    DivElement e = new DivElement()..classes.add("trive-claim");
    TextAreaElement get statement => e.querySelector('span');
    TextAreaElement get textarea => e.querySelector('textarea');

    ClaimEditor(this.claim) {
        e.setInnerHtml(HTML, treeSanitizer: NodeTreeSanitizer.trusted);
        e.querySelector('#save-trive-claim').onClick.listen(onSave);
        e.querySelector('#delete-trive-claim').onClick.listen(onDelete);
        e.querySelector('span').text = claim.statement;
    }

    onSave([_]) {
        claim.research = textarea.value;
        API.save(claim);
    }

    onDelete([_]) {

    }

}


class TrivePanel {

    static final HTML = """
        <button id='new-trive-claim'></button>
    """;

    DivElement e = new DivElement()..id="trive-panel";

    TrivePanel() {
        e.setInnerHtml(HTML, treeSanitizer: NodeTreeSanitizer.trusted);
        document.body.insertBefore(e, document.body.firstChild);
        e.querySelector('button').onClick.listen(sendSelection);
        //addFromMeta('og:title');
        //addFromMeta('og:description');
        //addFromMeta('og:url');
    }

    sendSelection([_]) {
        window.console.log(getFromMeta('og:url')??'http://trive.news');
        //window.console.log(getSelection());
        highlightCurrentSelection();
    }

    String getFromMeta(String prop) {
        for (var meta in querySelectorAll('meta[property="${prop}"]')) {
            return meta.attributes['content'];
        }
    }

    Map getSelection() {
        var sel = window.getSelection();
        var range = sel.getRangeAt(0);
        return {
            "start_"
            "start": range.startOffset,
            "end": range.endOffset,
            "text": range.toString()
        };
    }

}


main() => new TrivePanel();
