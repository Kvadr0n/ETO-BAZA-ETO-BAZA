<?php
$mysqli = new mysqli("mysql", "root", "Franklin5", "LAP_SDO_WORKBENCH");
$result = $mysqli->query($_GET["query"]);
if ($result === false)
	echo $mysqli->error;
else if ($result === true)
	echo "S";
else
{
	echo "<tr>";
	foreach ($result as $row)
	{
		echo '<tr style="font-weight: bold">';
		foreach ($row as $key => $value)
			echo "<td>$key</td>";
		echo "</tr>";
		break;
	}
	echo "</tr>";
	foreach ($result as $row)
	{
		echo "<tr>";
		foreach ($row as $value)
			echo "<td>$value</td>";
		echo "</tr>";
	}
}
?>