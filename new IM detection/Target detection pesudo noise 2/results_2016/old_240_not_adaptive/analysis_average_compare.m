clear;
close all;

path=pwd;
filePattern = fullfile(path, '/*.mat');
files = dir(filePattern);

for Index = 1:length(files)
    base_name = files(Index).name;
    [folder, name, extension] = fileparts(base_name);
    dummy=load(base_name);
    average=dummy.average;
    error=dummy.error;
    
    %plot
    hold on;
    figure(1);
    x=[0.3,0.5,1,2];
    color_code=rand(1,3);
    errorbar(x,average*100,error*100,'-gs',...
        'LineWidth',2,...
        'MarkerSize',10,...
        'MarkerEdgeColor',color_code,...
        'color',color_code);
    axis([min(x) max(x) 0 100])
    set(gca,'XTick',x);
    xlabel('target-mask separation [octaves]');
    ylabel('correct response [%]');  
end
legend('1000cf','2000cf','500cf','Location','northoutside','Orientation','horizontal');
hold off;
saveas(gca, [path,'\average compare'], 'pdf') %Save figure
