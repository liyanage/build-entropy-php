<?php

$p = new PDFlib();
$p->begin_document(null, null);
$p->set_info('Creator', 'test-pdf.php');
$p->set_info('Author', 'entropy.ch');
$p->set_info('Title', 'PDFlib Test');

$p->begin_page_ext(595, 842, "");
$font = $p->load_font("Helvetica-Bold", "winansi", "");

$p->setfont($font, 24.0);
$p->set_text_pos(50, 700);
$p->show("Hello world!");
$p->continue_text("(says PHP)");
$p->end_page_ext("");

$p->end_document("");

$buf = $p->get_buffer();
$len = strlen($buf);

header("Content-type: application/pdf");
header("Content-Length: $len");
header("Content-Disposition: inline; filename=hello.pdf");
print $buf;

$p->delete();

/*



PDF_set_info($p, "Creator", "hello.php");
PDF_set_info($p, "Author", "Rainer Schaaf");
PDF_set_info($p, "Title", "Hello world (PHP)!");

PDF_begin_page_ext($p, 595, 842, "");

$font = PDF_load_font($p, "Helvetica-Bold", "winansi", "");

PDF_setfont($p, $font, 24.0);
PDF_set_text_pos($p, 50, 700);
PDF_show($p, "Hello world!");
PDF_continue_text($p, "(says PHP)");
PDF_end_page_ext($p, "");

PDF_end_document($p, "");

$buf = PDF_get_buffer($p);
$len = strlen($buf);

header("Content-type: application/pdf");
header("Content-Length: $len");
header("Content-Disposition: inline; filename=hello.pdf");
print $buf;

PDF_delete($p);
*/

