#!/usr/bin/gnuplot -persist

reset
set ylabel "absolute error"
set xlabel "n"
set grid



plot "lrerrors.dat" with linespoints
