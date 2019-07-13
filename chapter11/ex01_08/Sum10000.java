class Sum10000
{
	public static void main(String args[])
	{
		int n = 10000;
		int sum = 0;

		/* Calculates the sum of the numbers from 1 to 1000 */
		for(int i=1; i<=n; i++)
		{
			sum = sum + i;
		}

		System.out.println("The sum is: "+sum);
	}
}
