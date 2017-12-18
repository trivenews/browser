import 'package:chrome/chrome_ext.dart' as chrome;
import 'package:angular/angular.dart';
import 'package:trive_core/trive_core.dart';


typedef Article CreateArticle();


@Injectable()
class SynchronizationService {

    final Map<String,Article> articles = {};

    chrome.ChromeRuntime _runtime;
    chrome.Port _port;

    SynchronizationService(this._runtime) {
        _port = _runtime.connect();
        _port.onMessage.listen((msg) => onMessage(msg.message));
    }

    Article getOrAddArticle(String url, CreateArticle createArticle) {
        if (!articles.containsKey(url)) {
            var article = articles[url] = createArticle();
            _port.postMessage({'action': 'subscribe', 'data': article.meta.map});
        }
        return articles[url];
    }

    submitBounty(String url, num bounty) {
        _port.postMessage({'action': 'bounty', 'data': {'url': url, 'bounty': bounty}});
    }

    onMessage(Map message) {
        var article = articles[message['data']['url']];
        if (article == null) return;
        if (message['action'] == 'state-update') {
            article.updateState(message['data']);
        }
    }

}
