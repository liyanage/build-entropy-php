<?php

$doc = new DOMDocument();
$doc->loadXML('<root><node/></root>');
echo $doc->saveXML();

