
#include <stdio.h>

void iterativeFibonacci(int);

int main() {
	int k, n;
	long int i = 0, j = 1, f;

	printf("Enter the range of the Fibonacci series: ");
	scanf("%d", &n);

	printf("Fibonacci Series: %d %d ", 0, 1);
	iterativeFibonacci(n);
	printf("\n");
	return 0;
}

void iterativeFibonacci(int n) {
	long int first = 0, second = 1, sum;

	while (n > 0) {
		sum = first + second;
		first = second;
		second = sum;
		printf("%1d ", sum);
		n--;
	}
}

