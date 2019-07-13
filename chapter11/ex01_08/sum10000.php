<?php
$n = 10000;
$sum = 0;

$time_start = microtime(true);
/* Calculates the sum of the numbers from 1 to 1000 */
for($i = 0; $i<=$n; $i++)
{
	$sum = $sum + $i;
}

echo "The sum is: $sum<br>";
$time_end = microtime(true);
$time = $time_end - $time_start;
echo "Calculated in $time seconds<br>";
?>
