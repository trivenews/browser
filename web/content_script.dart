import 'dart:html';
import 'dart:async';
import 'dart:convert';
import 'package:annotator/annotator.dart';


class API {

    static final String api_url = "http://localhost:8000/api";
    static final Map<String, String> headers = {
        "Content-Type": "application/json"
    };

    static Future<Map> save(Model model) async {
        try {
            var response = await HttpRequest.request(
                    "${api_url}/${model.type}/",
                    method: "POST",
                    requestHeaders: headers,
                    sendData: model.json
            );
            return JSON.decode(response.responseText);
        } catch(e) {
            return {};
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

    String id;

    String url;
    String title;
    String image = "";
    String description;
    String site_name;
    List<Author> authors;

    Map get map => {
        'url': url,
        'title': title,
        'image': image,
        'description': description,
        'site_name': site_name,
        //'authors': authors.map((a)=>a.json)
    };
}


class Bounty extends Model {
    final type = 'bounty';

    Article article;
    num amount;

    Map get map => {
        'article': article.id,
        'amount': amount,
    };
}


class Claim extends Model {
    final type = 'claim';

    Article article;

    String id;
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
        <button id='new-trive-claim'>Submit Bounty</button>
    """;

    /*static final HTML = """
        <button id='new-trive-claim'>Add Claim</button>
    """;*/

    DivElement e = new DivElement()..id="trive-panel";

    Article article = new Article();

    TrivePanel() {
        e.setInnerHtml(HTML, treeSanitizer: NodeTreeSanitizer.trusted);
        document.body.insertBefore(e, document.body.firstChild);
        e.querySelector('button').onClick.listen(submitBounty);
        postArticle();
    }

    postArticle() async {
        article.url = getFromMeta('og:url');
        article.title = getFromMeta('og:title');
        article.site_name = getFromMeta('og:site_name');
        article.description = getFromMeta('og:description');
        var response = await API.save(article);
        article.id = response['id'];
    }

    submitBounty([_]) async {
        window.console.log('submitting bounty');
        var bounty = new Bounty();
        bounty.article = article;
        bounty.amount = 10.00;
        window.console.log(bounty.json);
        await API.save(bounty);
    }

    addClaim([_]) {
        window.console.log('addClaim');
        highlightCurrentSelection();
        saveClaim();
        window.console.log('done');
    }

    saveClaim() async {
        window.console.log('saveClaim');
        var sel = window.getSelection();
        var range = sel.getRangeAt(0);
        var claim = new Claim();
        claim.article = article;
        claim.statement = range.toString();
        claim.selector = getCSSSelectorFromElement(range.startContainer);
        claim.start = range.startOffset;
        claim.length = claim.statement.length;
        window.console.log(claim.json);
        var response = await API.save(claim);
        claim.id = response['id'];
        window.console.log(response);
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
