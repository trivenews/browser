import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

import 'package:trive_core/trive_core.dart';
import 'synchronization_service.dart';
import 'claim.dart';

@Component(
    selector: 'trive-panel',
    styleUrls: const ['panel.css'],
    templateUrl: 'panel.html',
    directives: const [
        CORE_DIRECTIVES,
        ClaimComponent,
    ],
    providers: const [
        SynchronizationService,
        materialProviders,
    ],
)
class TrivePanel implements OnInit {

    final SynchronizationService _sync;

    TrivePanel(this._sync);

    Article article;

    void ngOnInit() => setCurrentArticle();

    /* TODO: needs to be called when URL changes
        on infinite scrolling news sites (eg. forbes.com) */
    setCurrentArticle() {
        var url = getFromMeta('og:url');
        article = _sync.getOrAddArticle(url, ()=>
            new Article({
                'url': url,
                'title': getFromMeta('og:title'),
                'description': getFromMeta('og:description'),
                'site_name': getFromMeta('og:site_name'),
                'image': getFromMeta('og:image')
            })
        );
    }

    String getFromMeta(String prop) {
        for (var meta in querySelectorAll('meta[property="${prop}"]')) {
            return meta.attributes['content'];
        }
        return null;
    }

    addBounty(String bountyString) {
        bountyString = bountyString.trim();
        if (bountyString.isEmpty) return;
        num bounty = num.parse(bountyString, (s)=>null);
        if (bounty != null) {
            _sync.submitBounty(article.meta.url, bounty);
        }
    }
    /*

    submitBounty([_]) async {
        var bounty = new Bounty()
            ..article = article
            ..amount = 10.00;
        port.postMessage({'bounty': bounty.map});
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
    */
}
