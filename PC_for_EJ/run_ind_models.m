clear;
clc
close all;

tic

%set seed
rng(1)

cd RRR_small
main_EJ

cd ../BGG
main_EJ

cd ../CK
main_EJ

cd ../JPT
main_EJ

cd ../RRR
main_EJ

toc