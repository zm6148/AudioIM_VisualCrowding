clear;
close all;

%% noise

% t_n_500_1 = 54.09;%0.3
% t_n_500_2 = 48.28;%0.5
% t_n_500_3 = 34.01;%1
% t_n_500_4 = 27.45;%1.5

t_n_1000_1 = 56.98;
t_n_1000_2 = 53.28;
t_n_1000_3 = 34.48;
t_n_1000_4 = 28.36;

t_n_2000_1 = 60.57;
t_n_2000_2 = 52.86;
t_n_2000_3 = 41.56;
t_n_2000_4 = 32.40;

% t_n_1500_1 = 55;
% t_n_1500_2 = 50;
% t_n_1500_3 = 32;
% t_n_1500_4 = 19;
% 
% t_n_750_1 = 52;
% t_n_750_2 = 44;
% t_n_750_3 = 30;
% t_n_750_4 = 20;
% 
% t_n_250_1 = 52;
% t_n_250_2 = 44;
% t_n_250_3 = 34;
% t_n_250_4 = 32;
%% tonal mask

t_m_1000_1 = 57.68;%0.3
t_m_1000_2 = 63.96;%0.5
t_m_1000_3 = 48.96;%1
t_m_1000_4 = 34.90;%1.5

t_m_2000_1 = 61.43;
t_m_2000_2 = 66.48;
t_m_2000_3 = 52.97;
t_m_2000_4 = 54.11;

% t_m_500_1 = 54.86;
% t_m_500_2 = 63.39;
% t_m_500_3 = 38.07;
% t_m_500_4 = 30.70;

% t_m_1000_1_n = 66;%0.3
% t_m_1000_2_n = 56;%0.5
% t_m_1000_3_n = 49;%1
% t_m_1000_4_n = 47;%1.5
% 
% t_m_2000_1_n = 69;
% t_m_2000_2_n = 68;
% t_m_2000_3_n = 60;
% t_m_2000_4_n = 57;
% 
% t_m_500_1_n = 57;
% t_m_500_2_n = 59;
% t_m_500_3_n = 49;
% t_m_500_4_n = 45;

%% plot 
x1 = ((2^(0.15)-2^(-0.15))/2); %0.3
x2 = ((2^(0.25)-2^(-0.25))/2); %0.5
x3 = ((2^(0.5)-2^(-0.5))/2);   %1
x4 = ((2^(0.75)-2^(-0.75))/2); %1.5

x= [x1, x2, x3, x4];

% nothced noise conditon
h=figure;
subplot(1,2,1);
hold on;
%plot(x, [t_n_500_1,t_n_500_2,t_n_500_3,t_n_500_4],'-ro');
plot(x, [t_n_1000_1,t_n_1000_2,t_n_1000_3,t_n_1000_4],'-ko');
plot(x, [t_n_2000_1,t_n_2000_2,t_n_2000_3,t_n_2000_4],'-go');

ylim([0,70]);
title('target threshold with notched noise and added broadband noise');
legend('1000 hz target','2000 hz target','Location','Best');

% toanl mask conditon
subplot(1,2,2);
hold on;
%plot(x, [t_m_500_1,t_m_500_2,t_m_500_3,t_m_500_4],'-ro');
plot(x, [t_m_1000_1,t_m_1000_2,t_m_1000_3,t_m_1000_4],'-ko');
plot(x, [t_m_2000_1,t_m_2000_2,t_m_2000_3,t_m_2000_4],'-go');

ylim([0,70]);
title('target threshold with tonal mask and added broadband noise');
legend('1000 hz target','2000 hz target','Location','Best');

path=pwd;
saveas(gca, [path,'\TFA'], 'pdf') %Save figure
