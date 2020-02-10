clear;
close all;



%% assign different color to subjects

% [1 0 0]	Bright red
% [1 0 1]	Pink
% [1 1 1]	White

% [0 0.251 0]	Dark green
% [0.502 0.502 0.502]	Gray

% [0 0.502 0.502]	Turquoise

% [1 0.502 0.502]	Peach

keySet =   {'TAA', 'TAB', 'TAC','TAE','TAF','TAK','TAN','TAI','TAS','TAU'};
color_code_set={[1 1 0],[0 0 0],[0 0 1],[0 1 0],[0 1 1],[0.9412 0.4706 0],[0.251 0 0.502],[0.502 0.251 0],[0.502 0.502 1],[0.502 0 0]};
% count=1;
% while count<=length(keySet)
%     color_code=rand(1,3);
%     alreadyExists = any(cellfun(@(x) isequal(x, color_code), color_code_set));
%     if alreadyExists==0
%         color_code_set=[color_code_set;color_code];
%         count=count+1;
%     else
%         color_code=rand(1,3);
%     end
%         
% end
color_code_all = containers.Map(keySet,color_code_set);

%% load data and plot

% load old file 240
path_old=uigetdir(pwd,'choose old all results folder');

filePattern = fullfile(path_old, '/*.mat');
files_old = dir(filePattern);

% % load new file each give one
% path_new=uigetdir(pwd,'choose new adaptive results folder');
% 
% filePattern = fullfile(path_new, '/*.mat');
% files_new = dir(filePattern);

% analysis  plot 240 percent correct %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
results_matrix=[];
legendInfo={};
name_list=[];
for Index = 1:length(files_old)
    base_name = files_old(Index).name;
    [folder, name, extension] = fileparts(base_name);
    subject_name_all=strsplit(base_name,'_');
    subject_name_cell=subject_name_all(1);
    subject_name=subject_name_cell{1};
    name_list=[name_list;subject_name];
    dummy=load(base_name);
    data=dummy.para_multi;
    if any(data(:,13)==0,1)==0
        x=unique(data(:,5));
        y=[];
        % disp(x);
        for i=1:length(x)
            y(i)=(sum(data(:,5)==x(i) & data(:,7)==data(:,13)))/(sum(data(:,5)==x(i)));
        end
        results_matrix=[results_matrix;y];
        
        %plot all in one graph
        a=figure(1);
        plot(x,y*100,'-gs',...
            'LineWidth',2,...
            'MarkerSize',10,...
            'color',color_code_all(subject_name));
        hold on;
        axis([0 max(x) 0 100])
        set(gca,'XTick',x);
        xlabel('target-mask separation [octaves]');
        ylabel('correct response [%]');   
        legendInfo=[legendInfo,subject_name];
    end   
end
legend(legendInfo,'Location','eastoutside','Orientation','vertical');
hold off;
saveas(gca, [path_old,'\all subject'], 'pdf') %Save figure

% average with error bar
average=mean(results_matrix,1);
if (length(files_old)-1)~= 0
    error=std(results_matrix,1)/sqrt((length(files_old)-1));
else
    error=results_matrix.*0;
end

b=figure(2);
errorbar(x,average*100,error*100,'-gs',...
    'LineWidth',2,...
    'MarkerSize',10,...
    'MarkerEdgeColor','b',...
    'MarkerFaceColor',[0.5,0.5,0.5])
axis([0 max(x) 0 100])
set(gca,'XTick',x);
xlabel('target-mask separation [octaves]');
ylabel('correct response [%]');
saveas(gca, [path_old,'\average'], 'pdf') %Save figure

%save average and error for each cf condition
string= strsplit(base_name,'_');
name=strcat(pwd,'\',string(length(string)));
save(name{1},'average','error','results_matrix','name_list');

% % analysis new one result each subject %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for Index = 1:length(files_new)
%     base_name = files_new(Index).name;
%     [folder, name, extension] = fileparts(base_name);
%     subject_name_all=strsplit(base_name,'_');
%     subject_name_cell=subject_name_all(1);
%     subject_name=subject_name_cell{1};
%     dummy=load(base_name);
%     data=dummy.para_multi;
% 	
% 	current=find(data(:,13)==0, 1, 'first'); %all trial finished
% 	separations=data(:,5);%all separations change in direction
% 	indexes_valley = findpeaks(max(separations)-separations);
% 	if length(separations)>=3 && ismember(subject_name, keySet)
% 		change_direction=length(indexes_valley);
% 	else
% 		change_direction=0;
% 	end
%     if change_direction>=12
% 		a=figure(1);
% 		hold on;
% 		threshold=data(current,5);
% 		plot([threshold threshold],get(gca,'ylim'),'LineWidth',2,'MarkerSize',10,'color',color_code_all(subject_name));
%         
%     end   
% end
% legend(legendInfo,'Location','eastoutside','Orientation','vertical');
% hold off;
% saveas(gca, [path_old,'\all subject'], 'pdf') %Save figure

