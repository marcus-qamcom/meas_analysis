clear all 
close all
clc

addpath('..\data')
addpath('helpfunctions')

testconftestcase

dist='0';
AP='3_Diversity';
dataAgeEvaluation('6', AP, dist, testconf,'DEF84L', 'PltonL');
dataAgeEvaluation('6', AP, dist, testconf,'DEF84L', 'DRF18L');
dataAgeEvaluation('6', AP, dist, testconf,'DEF84L', 'PlutoL');

AP='4_Diversity';
dataAgeEvaluation('6', AP, dist, testconf,'DEF84L', 'PltonL');
dataAgeEvaluation('6', AP, dist, testconf,'DEF84L', 'DRF18L');
dataAgeEvaluation('6', AP, dist, testconf,'DEF84L', 'PlutoL');

AP='5_Diversity';
dataAgeEvaluation('6', AP, dist, testconf,'DEF84L', 'PltonL');
dataAgeEvaluation('6', AP, dist, testconf,'DEF84L', 'DRF18L');
dataAgeEvaluation('6', AP, dist, testconf,'DEF84L', 'PlutoL');

AP='8_Diversity';
dataAgeEvaluation('6', AP, dist, testconf,'DEF84L', 'PltonL');
dataAgeEvaluation('6', AP, dist, testconf,'DEF84L', 'DRF18L');
dataAgeEvaluation('6', AP, dist, testconf,'DEF84L', 'PlutoL');

AP='9_Diversity';
dataAgeEvaluation('6', AP, dist, testconf,'DEF84L', 'PltonL');
dataAgeEvaluation('6', AP, dist, testconf,'DEF84L', 'DRF18L');
dataAgeEvaluation('6', AP, dist, testconf,'DEF84L', 'PlutoL');
