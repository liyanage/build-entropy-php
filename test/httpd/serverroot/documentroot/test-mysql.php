<?php

$socket = $_REQUEST['mysql_socket'];

#$db = mysql_connect(":$socket", 'root', '');


$db = mysql_connect("127.0.0.1:12346", 'unittest_dbuser', '123456');
$result = mysql_query('SELECT 1 + 1;', $db);
$row = mysql_fetch_array($result);

echo "db: $db, test value: $row[0]";
