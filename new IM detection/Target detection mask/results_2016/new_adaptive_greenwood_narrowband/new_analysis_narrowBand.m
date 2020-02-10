clear;
close all;



%% assign different shape to subjects

keySet =   {'TTAC', 'TTBA', 'TTBE', 'TTBI', 'TTBL', 'TTBT'};

% '+'	
% Plus sign
% 'o'	
% Circle
% '*'	
% Asterisk
% '.'	
% Point
% 'x'	
% Cross
% 'square' or 's'
% Square
% 'diamond' or 'd'
% Diamond
% '^'	
% Upward-pointing triangle
% 'v'	
% Downward-pointing triangle
% '>'	
% Right-pointing triangle
% '<'	
% Left-pointing triangle
% 'pentagram' or 'p'
% Five-pointed star (pentagram)
% 'hexagram' or 'h'
% Six-pointed star (hexagram)
% [1 0 0]	Bright red
% [1 0 1]	Pink
% [1 1 1]	White

% [0 0.251 0]	Dark green
% [0.502 0.502 0.502]	Gray

% [0 0.502 0.502]	Turquoise

% [1 0.502 0.502]	Peach


shape_set = {'+','o','*','d','x','s'};%'.','^','v','>','<','p','h'};
color_set={[1 1 0],[0 0 0],[0 0 1],[0 1 0],[0 1 1],[0.9412 0.4706 0]}; %[0.251 0 0.502],[0.502 0.251 0],[0.502 0.502 1],[0.502 0 0]};

shape_code_all = containers.Map(keySet,shape_set);
shape_color_all = containers.Map(keySet,color_set);


%% load data and plot

path=uigetdir(pwd,'choose results folder');

filePattern = fullfile(path, '/*.mat');
files = dir(filePattern);


results_matrix=[];
legendInfo={};
cf_500_threshold=[];
cf_1000_threshold=[];
cf_2000_threshold=[];
subject_name_list=[];
for Index = 1:length(files)
    base_name = files(Index).name;
    [folder, name, extension] = fileparts(base_name);
    subject_name_all=strsplit(base_name,'_');
    subject_name_cell=subject_name_all(1);
    subject_name_list=[subject_name_list,subject_name_cell];
    subject_name=subject_name_cell{1};
    subject_cf_cell=subject_name_all(4);
    subject_cf=subject_cf_cell{1};
    cf=strsplit(subject_cf,'.');
    center_freq=cf{1};
    
    dummy=load(base_name);
    data=dummy.para_multi;
    
    current=find(data(:,13)==0, 1, 'first'); %all trial finished
    separations=data(:,5);%all separations change in direction
    indexes_valley = findpeaks(max(separations)-separations);
    disp(indexes_valley);
    if length(separations)>=3
        change_direction=length(indexes_valley);
    else
        change_direction=0;
    end
       
    if change_direction>=12    
        fig1=figure(Index);
        for ii=1:current-1
            if (data(ii,7)== data(ii,13))
                color=[0,1,0];
            else
                color=[1,0,0];
            end
        
            hold on;
            plot(ii ,data(ii,5), '-x', 'markersize',10,'color',color);
            
            % average of last 6 separation
            last_index=indexes_valley(length(indexes_valley)-5:length(indexes_valley));
            disp(last_index);
            threshold=2-mean(last_index);
            
            %plot
            line(xlim,[threshold threshold],'Color','b')
            ylim([0,3]);
            string=['subject ',subject_name, ' Threshold at ',num2str(center_freq),' is ',num2str(threshold)];
            title(string);   
            hold off;
        end
        %save
        name=[path,'/plots/',subject_name, ' Threshold at ',num2str(center_freq)];
        saveas(gcf,[name,'.pdf']);
        
        %different cfs
        switch center_freq
            case '500cf'
                cf_500_threshold=[cf_500_threshold,threshold];
            case '1000cf'
                cf_1000_threshold=[cf_1000_threshold,threshold];
            case '2000cf'
                cf_2000_threshold=[cf_2000_threshold,threshold];
        end
    end   
end

fig2=figure();        
%plot threshold at different cf
% average with error bar
average_500=mean(cf_500_threshold);
error_500=std(cf_500_threshold)/sqrt((length(cf_500_threshold)));

average_1000=mean(cf_1000_threshold);
error_1000=std(cf_1000_threshold)/sqrt((length(cf_1000_threshold)));

average_2000=mean(cf_2000_threshold);
error_2000=std(cf_2000_threshold)/sqrt((length(cf_2000_threshold)));

cfs=[500,1000,2000];

averages=[average_500,average_1000,average_2000];
errors=[error_500,error_1000,error_2000];

errorbar(cfs,averages,errors,'-gs',...
    'LineWidth',2,...
    'MarkerSize',10,...
    'MarkerEdgeColor','b',...
    'MarkerFaceColor',[0.5,0.5,0.5]);
xlabel('Target Center frequence');
ylabel('Treshold in Octave');
%save
saveas(gcf,'thresholds.pdf');

%% new way to plot
fig3=figure();  
name_list = unique(subject_name_list);

for ii = 1:length(name_list)
    hold on;
    plot(1, cf_500_threshold(ii),shape_code_all(char(name_list(ii))),'markersize', 6, 'color', shape_color_all(char(name_list(ii))));
    %plot(1, average_500, '.', 'color', 'r', 'markersize', 20); 
    plot(2, cf_1000_threshold(ii),shape_code_all(char(name_list(ii))),'markersize', 6, 'color', shape_color_all(char(name_list(ii))));
    %plot(2, average_1000, '.', 'color', 'r', 'markersize', 20); 
    plot(3, cf_2000_threshold(ii),shape_code_all(char(name_list(ii))),'markersize', 6, 'color', shape_color_all(char(name_list(ii))));
    %plot(3, average_2000, '.', 'color', 'r', 'markersize', 20); 
    xlim([0 4]);
    set(gca,'XTick',[0 1 2 3 4]);
    set(gca,'XTickLabel',{' ','500 cf','1000 cf','2000cf',' '});
    errorbar(cfs,averages,errors,'-gs',...
        'LineWidth',2,...
        'MarkerSize',10,...
        'MarkerEdgeColor','b',...
        'MarkerFaceColor',[0.5,0.5,0.5]);
    xlim([0 4]);
    xlabel('Target Center frequence');
    ylabel('Treshold in Octave');
end



