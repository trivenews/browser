@TestOn('browser')
import 'dart:html';
import 'package:test/test.dart';
import 'package:annotator/annotator.dart';

void main() {

    group("CSSSelector", () {

        test("calculate selector path", () {
            expect(getCSSSelectorFromElement(querySelector('b')),
                    'body>article:nth-child(1)>div:nth-child(1)>p:nth-child(3)>b:nth-child(1)');
            expect(getCSSSelectorFromElement(querySelector('b.with-class')),
                    '#p-with-id>b:nth-child(1)');
        });

    });
}
