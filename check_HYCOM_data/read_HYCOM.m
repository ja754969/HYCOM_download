clear;clc;close all
%%
start_date = '2021100100';
end_date = '2021103121';
%%
LON_lim = [117 137];
LAT_lim = [10 30];
LON_lim_zoomin = [120 125];
LAT_lim_zoomin = [18 25];
%%
first_date = datetime(start_date,'InputFormat','yyyyMMddHH');
last_date = datetime(end_date,'InputFormat','yyyyMMddHH');
%%
index_num = hours(last_date-first_date)/3+1;
%%
data_folder = 'D:/Data/processed/HYCOM/HYCOM_GLBy_surface_uv/';
u_HYCOM = [];
v_HYCOM = [];
%% Plotting data for checks (GIF)
scale = 0.1;
fig = figure;
fig.PaperUnits = 'centimeters';
fig.PaperSize = [29.7 21]; % A4 papersize (horizontal,21-by-29.7 cm,[width height])
fig.PaperType = '<custom>';
fig.WindowState = 'maximized';
fig
ax1 = axes;
pic_num = 1;
for i = 1:index_num
    the_date = first_date+hours(1)*(i*3-3);
    yyyy = num2str(year(the_date));
    MM = num2str(month(the_date),'%02.0f'); 
    dd = num2str(day(the_date),'%02.0f'); 
    HH = num2str(hour(the_date),'%02.0f');
    load([data_folder yyyy MM dd HH]);
    date_str(i,:) = [yyyy MM dd HH];
    disp([yyyy MM dd HH]);
    u_i = double(permute(u,[2 1]));
    v_i = double(permute(v,[2 1]));
    u_HYCOM = cat(3,u_HYCOM,u_i);
    v_HYCOM = cat(3,v_HYCOM,v_i);
    [XX_lon,YY_lat] = meshgrid(lon,lat);
    % Figure
%     m_proj('Mercator','lon',[LON_lim(1) LON_lim(end)],'lat',[LAT_lim(1) LAT_lim(end)]);
    m_proj('Mercator','lon',[LON_lim_zoomin(1) LON_lim_zoomin(end)],...
        'lat',[LAT_lim_zoomin(1) LAT_lim_zoomin(end)]);

    m_gshhs_h('patch',[0.7 0.7 0.7]);
    hold on;
%     mqr = m_quiver(XX_lon,YY_lat,u_HYCOM(:,:,i),v_HYCOM(:,:,i),0);
    mqr = m_quiver(XX_lon,YY_lat,u_i,v_i,0);
    mqr.Color = 'b';
    mqr.LineWidth = 1;
    mqr.MaxHeadSize = 1;
    hU1 = get(mqr,'UData');
    hV1 = get(mqr,'VData');
    set(mqr,'UData',scale*hU1,'VData',scale*hV1)
    hold on;
    m_grid('tickdir','out','FontSize',25,'FontWeight','bold','LineWidth',3)
    title(date_str(i,:),'FontSize',15)
    hold off;
    % GIF
    drawnow
    F = getframe(gcf);
    I = frame2im(F);
    [I,map] = rgb2ind(I,256);
    if pic_num == 1
        imwrite(I,map,'test_HYCOM.gif','gif','LoopCount',inf,'DelayTime',1)
    else
        imwrite(I,map,'test_HYCOM.gif','gif','WriteMode','append','DelayTime',1)
    end
    pic_num = pic_num+1;
    clf
end
%%
u_HYCOM_mean = mean(u_HYCOM,3,'omitnan');
v_HYCOM_mean = mean(v_HYCOM,3,'omitnan');
%%
%% Plotting data for checks (mean)
% scale = 0.005;
% fig = figure;
% fig.PaperUnits = 'centimeters';
% fig.PaperSize = [29.7 21]; % A4 papersize (horizontal,21-by-29.7 cm,[width height])
% fig.PaperType = '<custom>';
% fig.WindowState = 'maximized';
% fig
% ax1 = axes;
% m_proj('Mercator','lon',[LON_lim(1) LON_lim(end)],'lat',[LAT_lim(1) LAT_lim(end)]);
% % m_proj('Mercator','lon',[LON_lim_zoomin(1) LON_lim_zoomin(end)],...
% %     'lat',[LAT_lim_zoomin(1) LAT_lim_zoomin(end)]);
% 
% m_gshhs_h('patch',[0.7 0.7 0.7]);
% hold on;
% mqr = m_quiver(XX_lon,YY_lat,u_HYCOM_mean,v_HYCOM_mean);
% mqr.Color = 'b';
% mqr.LineWidth = 2;
% mqr.MaxHeadSize = 1;
% hU1 = get(mqr,'UData');
% hV1 = get(mqr,'VData');
% set(mqr,'UData',scale*hU1,'VData',scale*hV1)
% hold on;
% m_grid('tickdir','out','FontSize',25,'FontWeight','bold','LineWidth',3)
% title([char(first_date) ' - ' char(last_date)],'FontSize',15)