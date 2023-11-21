#include <stdio.h>

int main() {
    FILE *file = fopen("right_rects.txt", "r");

    double a = 10, b = 0;

    fscanf(file, "%lf %lf", &a, &b);

    printf("%lf %lf\n", a, b);

    return 0;
}
