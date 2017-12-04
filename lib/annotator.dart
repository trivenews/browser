import 'dart:html';


Iterable<Node> nextOrParentSibling(Node root) sync* {
    if (root.nextNode != null) {
        yield* traverse(root.nextNode);
    } else {
        var node = root.parentNode;
        while (node != null) {
            if (node.nextNode != null) {
                yield* traverse(node.nextNode);
                break;
            }
            node = node.parentNode;
        }
    }
}


Iterable<Node> traverse(Node root) sync* {
    window.console.log('start traverse for ${root.nodeName}');
    if (root.nodeName == 'TRIVE-CLAIM') {
        yield* nextOrParentSibling(root);
    } else {
        yield root;
        for (var node in root.childNodes) {
            yield* traverse(node);
            yield node;
        }
        yield* nextOrParentSibling(root);
    }
}


String getCSSSelectorFromElement(Element node) {

    var parts = [];

    while (node != null) {

        if (node.attributes.containsKey('id')) {
            var nodeId = node.attributes['id'];
            var other = document.getElementById(nodeId);
            if (node == other) {
                // short circuit everything, we've got unique starting point
                parts.insert(0, '#$nodeId');
                return parts.join('>');
            }
        }

        var pos = 1;
        var sibling = node;
        while (sibling.previousElementSibling != null) {
            if (node.tagName == sibling.previousElementSibling.tagName) {
                pos++;
            }
            sibling = sibling.previousElementSibling;
        }

        parts.insert(0, '${node.localName}:nth-child($pos)');

        if (node.parentNode.nodeName == "BODY") {
            // we've reached the content root
            parts.insert(0, 'body');
            return parts.join('>');
        }

        node = node.parentNode;

    }

    return parts.join('>');
}


void highlightCurrentSelection() {
    var sel = window.getSelection();
    var range = sel.getRangeAt(0);
    highlightSelection(range.startContainer, range.startOffset, range.toString().length);
}


void highlightSelection(Node start, int startOffset, int selectionLength) {
    Node node;
    for (node in traverse(start)) {
        if (node.nodeType == Node.TEXT_NODE && node.parentNode.nodeName != 'TRIVE_CLAIM') {
            var length = (node as Text).length;
            if (startOffset >= length) {
                startOffset -= length;
            } else {
                if (startOffset > 0) {
                    node = (node as Text).splitText(startOffset);
                    length = (node as Text).length;
                    startOffset = 0;
                }
                if ((selectionLength < length)) {
                    (node as Text).splitText(selectionLength);
                }
                var trive_claim = document.createElement('trive-claim');
                node.replaceWith(trive_claim);
                trive_claim.append(node);
                selectionLength -= length;
                if (selectionLength <= 0) {
                    break;
                }
            }
        }
    }
}
