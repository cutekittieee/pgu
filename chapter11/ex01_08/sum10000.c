#include <stdio.h>

int main(int argc, char **argv)
{
	int n = 10000;
	int sum = 0;

	/* Calculates the sum of the numbers from 1 to 1000 */
	for(int i = 1; i<=n; i++)
	{
		sum = sum + i;
	}

	printf("The sum is: %d\n", sum);
	return 0;
}
