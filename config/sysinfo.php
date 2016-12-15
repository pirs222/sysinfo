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
		// выводим историю
		$res = $mysqli->query("SELECT  id,date FROM log WHERE id=$id;");
	}
	else{
		// выводим последние данные
		$res = $mysqli->query("SELECT  id,date FROM log ORDER BY id DESC LIMIT 1;");
	}

	$row = $res->fetch_assoc();
	$log_id=$row['id'];
	$date=$row['date'];
 
 	//  current data button
 	if ($id>0){
 		echo "<a href='sysinfo'><button>Current data</button></a>";
 	}
 	// Prev data button
	if($log_id>1){
			echo "<a href='sysinfo?q=".($log_id-1)."'><button>Prev data</button></a>";
	};	

// show data log
	echo "<h1 class='ok'>Datetime (UTC): $date  id: $log_id</h1>";

	$res = $mysqli->query("SELECT  name,data FROM section  WHERE log_id=$log_id ORDER BY id");

while ($section = $res->fetch_assoc()) {
	$name= $section['name'];
	$data = $section['data'];
	// заголовок секции	
	echo "<h2>$name</h2>";
	// строка данных
	echo "<pre>$data</pre><hr>";
}

?>
	</body>
</html>