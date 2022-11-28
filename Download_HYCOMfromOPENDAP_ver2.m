clear,clc
latlim = [10 50];
lonlim = [110 270];
firstdate = datenum('2000010100','yyyymmddHH');
fn_i = ['https://tds.hycom.org/thredds/dodsC/GLBy0.08/expt_93.0/uv3z?lat[0:1:4250],lon[0:1:4499]'];  
lon_i = ncread(fn_i,'lon');
lat_i = ncread(fn_i,'lat');
lonindex = find(lon_i>=lonlim(1)&lon_i<=lonlim(end))-1;
latindex = find(lat_i>=latlim(1)&lat_i<=latlim(end))-1;

%%
t = 7907; %起始時間index
while t <=10968 
    %https://tds.hycom.org/thredds/dodsC/GLBy0.08/expt_93.0/uv3z?lat[0:1:4250],lon[0:1:4499],time[0:1:10968],water_u[0:1:0][0:1:0][0:1:0][0:1:0],water_v[0:1:0][0:1:0][0:1:0][0:1:0]
    fn = ['https://tds.hycom.org/thredds/dodsC/GLBy0.08/expt_93.0/uv3z?lat[' ...
        num2str(latindex(1)) ':1:' num2str(latindex(end)) ...
        '],lon[' num2str(lonindex(1)) ':1:' num2str(lonindex(end)) ...
        '],time[' num2str(t) '],water_u[' num2str(t) ...
        '][0:1:0][' num2str(latindex(1)) ':1:' num2str(latindex(end)) ...
        '][' num2str(lonindex(1)) ':1:' num2str(lonindex(end)) ...
        '],water_v[' num2str(t) '][0:1:0][' num2str(latindex(1)) ':1:' ...
        num2str(latindex(end)) '][' num2str(lonindex(1)) ':1:' ...
        num2str(lonindex(end)) ']'];
%     depth = ncread(fn,'depth');
    try
    lat = ncread(fn,'lat');
    lon = ncread(fn,'lon');
    u = ncread(fn,'water_u');
    v = ncread(fn,'water_v');
    time = ncread(fn,'time');
    date = datestr([firstdate + time/24],'yyyymmddHH')
% 	save(['F:\1_Tec_all\DATA\HYCOM\HYCOM_GLBy_surface_uv\' date],'lat','lon','u','v')
    save(['./DATA/HYCOM/HYCOM_GLBy_surface_uv/' date],'lat','lon','u','v')
    
    catch   %如果error,等待60秒並再執行一次
        disp('error')
        t = t - 1;
        pause(60)
        
    end
    clear depth lat lon u v time date
    t = t + 1;
end
