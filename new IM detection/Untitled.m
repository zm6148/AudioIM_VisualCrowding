clear;
close all;

%% noise

t_n_500_1 = 50;%0.3
t_n_500_2 = 44;%0.5
t_n_500_3 = 31;%1
t_n_500_4 = 22;%1.5

t_n_1000_1 = 50;
t_n_1000_2 = 47;
t_n_1000_3 = 28;
t_n_1000_4 = 15;

t_n_2000_1 = 55;
t_n_2000_2 = 46;
t_n_2000_3 = 30;
t_n_2000_4 = 21;

t_n_1500_1 = 55;
t_n_1500_2 = 50;
t_n_1500_3 = 32;
t_n_1500_4 = 19;

t_n_750_1 = 52;
t_n_750_2 = 44;
t_n_750_3 = 30;
t_n_750_4 = 20;

t_n_250_1 = 52;
t_n_250_2 = 44;
t_n_250_3 = 34;
t_n_250_4 = 32;
%% tonal mask

t_m_1000_1 = 57;%0.3
t_m_1000_2 = 58;%0.5
t_m_1000_3 = 40;%1
t_m_1000_4 = 16;%1.5

t_m_2000_1 = 70;
t_m_2000_2 = 70;
t_m_2000_3 = 70;
t_m_2000_4 = 54;

t_m_500_1 = 62;
t_m_500_2 = 60;
t_m_500_3 = 43;
t_m_500_4 = 31;

t_m_1500_1 = 60;
t_m_1500_2 = 62;
t_m_1500_3 = 47;
t_m_1500_4 = 29;

t_m_750_1 = 56;
t_m_750_2 = 60;
t_m_750_3 = 38;
t_m_750_4 = 14;

t_m_250_1 = 58;
t_m_250_2 = 51;
t_m_250_3 = 46;
t_m_250_4 = 39;

%% plot 
x1 = ((2^(0.15)-2^(-0.15))/2); %0.3
x2 = ((2^(0.25)-2^(-0.25))/2); %0.5
x3 = ((2^(0.5)-2^(-0.5))/2);   %1
x4 = ((2^(0.75)-2^(-0.75))/2); %1.5

x= [x1, x2, x3, x4];

% nothced noise conditon
subplot(1,2,1);
hold on;
plot(x, [t_n_250_1,t_n_250_2,t_n_250_3,t_n_250_4],'-co');
plot(x, [t_n_500_1,t_n_500_2,t_n_500_3,t_n_500_4],'-ro');
plot(x, [t_n_750_1,t_n_750_2,t_n_750_3,t_n_750_4],'-ko');
plot(x, [t_n_1000_1,t_n_1000_2,t_n_1000_3,t_n_1000_4],'-go');
plot(x, [t_n_1500_1,t_n_1500_2,t_n_1500_3,t_n_1500_4],'-yo');
plot(x, [t_n_2000_1,t_n_2000_2,t_n_2000_3,t_n_2000_4],'-bo');

ylim([0,70]);
title('target threshold with notched noise');
legend('250 hz target','500 hz target','750 hz target','1000 hz target','1500 hz target','2000 hz target','Location','Best');

% toanl mask conditon
subplot(1,2,2);
hold on;
plot(x, [t_m_250_1,t_m_250_2,t_m_250_3,t_m_250_4],'-co');
plot(x, [t_m_500_1,t_m_500_2,t_m_500_3,t_m_500_4],'-ro');
plot(x, [t_m_750_1,t_m_750_2,t_m_750_3,t_m_750_4],'-ko');
plot(x, [t_m_1000_1,t_m_1000_2,t_m_1000_3,t_m_1000_4],'-go');
plot(x, [t_m_1500_1,t_m_1500_2,t_m_1500_3,t_m_1500_4],'-yo');
plot(x, [t_m_2000_1,t_m_2000_2,t_m_2000_3,t_m_2000_4],'-bo');


ylim([0,70]);
title('target threshold with tonal mask');
legend('250 hz target', '500 hz target','750 hz target','1000 hz target','1500 hz target','2000 hz target','Location','Best');

path=pwd;
saveas(gca, [path,'\min'], 'pdf') %Save figure
