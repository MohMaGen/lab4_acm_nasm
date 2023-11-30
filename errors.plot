#!/usr/bin/gnuplot -persist

reset
set ylabel "absolute error"
set xlabel "methods"
set grid


set style data histogram 
set style fill solid border -1
binwidth = 0.2
set boxwidth binwidth

plot "errors.dat" u (column(0)):2:xtic(1) w boxes title ""
