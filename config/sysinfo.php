<!doctype html>

<html lang="en">
	<head>
	  <meta charset="utf-8">

	  <title>SysInfo</title>
	  <link rel="stylesheet" href="style.css">
	</head>
	<body>
	
<?php

// Соединяемся, выбираем базу данных
	$mysqli = new mysqli('localhost', 'root', 'mysqlpass',"sysinfo");


	$id=intval($_GET["q"]);
	if ($id>0){
		$res = $mysqli->query("SELECT  id,date FROM log WHERE id=$id;");
	}
	else{
		$res = $mysqli->query("SELECT  id,date FROM log ORDER BY id DESC LIMIT 1;");
	}

	$row = $res->fetch_assoc();
	$log_id=$row['id'];
	$date=$row['date'];
	if($log_id>1){
			echo "<a href='sysinfo.php?q=".($log_id-1)."'><button>Prev data</button></a>";
	};	

// show data log
	echo "<h1 class='ok'>Datetime (UTC): $date  id: $log_id</h1>";

	$res = $mysqli->query("SELECT  id,name FROM section  WHERE log_id=$log_id ORDER BY id");

while ($section = $res->fetch_assoc()) {
	$section_id= $section['id'];
	$name= $section['name'];
// заголовок секции
	echo "<h2>$name</h2>";

	$res2 = $mysqli->query("SELECT  datarow FROM  data  WHERE section_id=$section_id ORDER BY id");
	while ($row = $res2->fetch_assoc()) {
		$datarow = $row['datarow'];
		// строка данных
		echo "<pre>$datarow</pre><hr>";
	}
}

?>
	</body>
</html>