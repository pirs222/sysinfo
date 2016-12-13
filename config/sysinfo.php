<!doctype html>

<html lang="en">
	<head>
	  <meta charset="utf-8">

	  <title>SysInfo</title>
	  <link rel="stylesheet" href="css/styles.css?v=1.0">
	  <style media="screen" type="text/css">
			.ok{
				color: white;
				background-color:darkgreen;
			}
			.warn{
				background-color:orange;
			}
			.fail,.error{
				color: white;
				background-color:red;
			}
			td{
				padding:0 10px;
			}
			h2{
				margin:20px 0 0 0;
			}
		</style>
	</head>
	<body>
	
<?php
// Соединяемся, выбираем базу данных
	$mysqli = new mysqli('localhost', 'root', 'mysqlpass',"sysinfo");
	$res = $mysqli->query("SELECT  id,date FROM logs ORDER BY id DESC LIMIT 1;");
	$row = $res->fetch_assoc();
	
	$usersTimezone = new DateTimeZone('Europe/Moscow');
	$l10nDate = new DateTime($row['date']);
	$l10nDate->setTimeZone($usersTimezone);
	$logs_id=$row['id'];
	echo "<h1>Datetime: ".$l10nDate->format('Y-m-d H:i:s')."  id: ".$logs_id."</h1>";

	$res = $mysqli->query("SELECT  id,name FROM params  WHERE logs_id=".$logs_id." ORDER BY id");

while ($row = $res->fetch_assoc()) {
	$params_id= $row['id'];
	$name= $row['name'];
	echo "<h2>".$name."</h2>";
	echo "<table>";
	$res2 = $mysqli->query("SELECT  id,name FROM `values`  WHERE params_id=".$params_id." ORDER BY id");
	while ($row2 = $res2->fetch_assoc()) {
		echo "<tr>";
			foreach($row2 as $item){
					echo "<td>".$item."</td>";
			};
		echo "</tr>";
	}
	echo "</table>";

}

?>
	<h2>Load Average</h2>
		<table>
			<tr>
				<td>Param</td>
				<td class="ok">12</td>
				<td class="warn">234</td>
				<td class="error">2345</td>
			</tr>
		</table>

	</body>
</html>