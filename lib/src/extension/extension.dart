import 'dart:html';
import 'dart:convert';
import 'package:chrome/chrome_ext.dart' as chrome;

import 'package:trive_core/trive_core.dart';
import 'session.dart';


class TriveChromeExtension {

    final Map<String,Article> articles = {};
    final Map<String,List<chrome.Port>> articleSubscribers = {};

    WebSocket _socket;
    chrome.ChromeRuntime _runtime;
    Session _session;

    TriveChromeExtension(this._runtime, this._session) {
        setupServerMessaging();
        setupPageMessaging();
    }

    setupBrowser() {
        chrome.browserAction.onClicked.listen((tab) {
        });
    }

    setupCookies() {
        chrome.browserAction.onClicked.listen((tab) {
        });
    }

    setupServerMessaging() {
        var protocol = (window.location.protocol == 'https:') ? 'wss:' : 'ws:';
        _socket = new WebSocket("${protocol}//localhost:8000");
        _socket.onMessage.listen((event) => onServerMessage(JSON.decode(event.data)));
        _socket.onClose.listen(onServerDisconnect);
    }

    onServerMessage(Map message) {
        var article = articles[message['data']['url']];
        if (message['action'] == 'meta-request') {
            _socket.send(JSON.encode({'action': 'meta', 'data': article.meta.map}));
        } else if (message['action'] == 'state-update') {
            article.updateState(message['data']);
            postMessage(article.url, message)
        }
    }

    onServerDisconnect(CloseEvent event) {

    }

    setupPageMessaging() {
        _runtime.onConnect.listen((port) {
            port.onMessage.listen((event) => onPageMessage(port, event.message));
            port.onDisconnect.listen((event) => disconnectPort(port));
        });
    }

    onPageMessage(chrome.Port port, Map message) {
        if (message['action'] == 'subscribe') {
            var url = message['data']['url'];
            if (!articles.containsKey(url)) {
                articles[url] = new Article(message['data']);
                _socket.send(JSON.encode({'action': 'subscribe', 'data': {'url': url}}));
            }
            var listeners = articleSubscribers.putIfAbsent(url, ()=>[]);
            if (!listeners.contains(port)) {
                listeners.add(port);
            }
        } else if (message['action'] == 'claim') {

        } else if (message['action'] == 'bounty') {

        }
    }

    postMessage(String url, Map message) {
        for (var port in articleSubscribers[url])
            port.postMessage(message);
    }

    disconnectPort(chrome.Port port) {
        for (var listeners in articleSubscribers.values) {
            listeners.remove(port);
        }
    }

}
