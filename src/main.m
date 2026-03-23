clc;clear; close all


% prepare data

[sma, cap]= DataPrepare("ABC_consolas_bold.png");
I = imread('text2.png');
ExtractTextFromImage(I,cap,sma);
