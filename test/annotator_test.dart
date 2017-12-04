@TestOn('browser')
import 'dart:html';
import 'package:test/test.dart';
import 'package:annotator/annotator.dart';

void main() {

    group("CSSSelector", () {

        test("calculate selector path", () {
            expect(getCSSSelectorFromElement(querySelector('b')),
                    'body>article:nth-child(1)>div:nth-child(2)>p:nth-child(1)>b:nth-child(1)');
            expect(getCSSSelectorFromElement(querySelector('b.with-class')),
                    '#p-with-id>b:nth-child(1)');
        });

    });

    group("Highlight Selection", () {

        test("highlight selection 1", () {
            var sel = window.getSelection();
            var range = new Range();
            range.setStart(querySelector('p').firstChild, 6);
            range.setEnd(querySelector('p.second').firstChild, 6);
            sel.removeAllRanges();
            sel.addRange(range);
            expect(range.toString(), 'world second');
            expect(
                querySelector('div.main').innerHtml,
                '<p>hello world</p> <p class="second">second paragraph</p>'
            );
            highlightCurrentSelection();
            expect(
                querySelector('div.main').innerHtml,
                '<p>hello <trive-claim>world</trive-claim></p><trive-claim> </trive-claim><p class="second"><trive-claim>second</trive-claim> paragraph</p>'
            );
        });

        test("highlight selection 2", () {
            var sel = window.getSelection();
            var range = new Range();
            ParagraphElement p = querySelector('p.longer');
            range.setStart(p.firstChild, 2);
            range.setEnd(p.firstChild, 38);
            sel.removeAllRanges();
            sel.addRange(range);
            expect(range.toString(), 'much longer sentence without various');
            expect(p.innerHtml, 'A much longer sentence without various markup.');
            highlightCurrentSelection();
            expect(p.innerHtml, 'A <trive-claim>much longer sentence without various</trive-claim> markup.');
        });

    });

}
