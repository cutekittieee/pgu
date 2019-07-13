#!/usr/bin/perl
$n = 10000;
$sum = 0;

#Calculates the sum of the numbers from 1 to 1000
for( $i = 1; $i <= $n; $i=$i+1 )
{
	$sum = $sum + $i;
}

print "The sum is: $sum\n"
