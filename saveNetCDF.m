function [ncdat] = saveNetCDF(data, long_name, units, sdir, sname);

%-----------------------------------------------------------------------
% Save array data from matlab structure to netCDF format:
%
% Usage: saveNetCDF(data, long_name, units, dir)
%
% INPUT:
% data =  Single-level Matlab data structure, where each field corresponds 
% to a variable you wish to save to netCDF. The names of each variable in 
% the structure will be used to save the data in netCDF.
%	e.g. data.time, data.lat;
% long_name = Cell array of the long hand names for each variable/field in
% the structure. 
%	e.g. long_name = {‘Julian day (2018)’; ‘North latitude’};
% units = Cell array containing identifying the units of each variable.
% 	e.g. units = {‘Days since 1 Jan. 2018’; ‘deg. N’};
% sdir = directory where the data will be saved (string) - EXCLUDING
% EXTENSION; if not specified, will save in cd
% sname = save name (string) - EXCLUDING EXTENSION; if not specified, will
% save as 'robert_is_cool';
%
% OUTPUT:
% ncdat = netCDF data (ncdat.variables and ncdat.netcdf);
% saves netCDF data file to specified save directory - have a look!! :)
%
% R. Izett (rizett@eoas.ubc.ca)
% UBC, Oceanography
% Last updated: Jan. 2018
%-----------------------------------------------------------------------

if ~exist('sdir','var')
	sdir = cd;
end

if ~exist('sname','var')
    sname = 'robert_is_cool';
end

%--- get fields from data structure
	fds = fields(data); 

%--- open/create file
    ncid = netcdf.create([sdir,'./',sname,'.nc'],'NC_WRITE');
    
%--- build netCDF variable
    for kk = 1:numel(fds)
        %get data and variable name
            this_dat = data.(fds{kk}); %data
            this_nom = fds{kk}; %name

        %Define variable dimension
            dimid(kk) = netcdf.defDim(ncid,this_nom,length(this_dat));
        %Define ID for the array variable
            dat_id(kk) = netcdf.defVar(ncid,this_nom,'double',[dimid(kk)]);
        %Add attributes
            netcdf.putAtt(ncid,dat_id(kk),'Units',units{kk})
            netcdf.putAtt(ncid,dat_id(kk),'Full Name',long_name{kk})
        %Add global attribute and finish defining variables
            if kk == numel(fds)    
                glob = netcdf.getConstant('GLOBAL');
                netcdf.putAtt(ncid,glob,'Date Saved:',datestr(now));
                netcdf.endDef(ncid);
            end
    end

%--- Store data
    for kk = 1:numel(fds);
        %get data and variable name
            this_dat = data.(fds{kk}); %data
            this_nom = fds{kk}; %name
        
        %store
            netcdf.putVar(ncid,dat_id(kk),this_dat);
        
        clear this_data this_nom
    end

%--- Close and save
    netcdf.close(ncid)

%--- load and return
    ncdat = ncdataset([sdir,'\',sname,'.nc']);

end



