import 'dart:html';


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