function [ncdat] = saveNetCDF(data, long_name, units, comment, global_name, global_string, sdir, sname);

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
% comment = Cell array containing comments corresponding with each
%   variable/long_name/units. 
%   Create blank array of cells (e.g. repmat(' ',size(long_name)) to add no
%   comments
%   e.g. comment = {' '; 'ship's GPS; decimal degrees'};
% global_name = Cell array of names for global attributes
%   e.g. global_name = {'Program';'Platform';'PI name/contact'};
% global_string = Cell array of string / text to populate with each global
%   name
%   e.g. global_string = {'test save';'my computer';'rizett@eoas.ubc.ca'};
% sdir = directory where the data will be saved (string); 
%   if not specified, will save in cd
% sname = save name (string) - EXCLUDING EXTENSION; if not specified, will
%   save as 'robert_is_cool';
%
% OUTPUT:
% ncdat = netCDF data (ncdat.variables and ncdat.netcdf);
% saves netCDF data file to specified save directory - have a look!! :)
%
% R. Izett (rizett@eoas.ubc.ca)
% UBC, Oceanography
% Last updated: Nov. 2020
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
    current = cd;
    cd(sdir);
    if ispc        
        if isempty(dir(['*',sname,'*']))
            ncid = netcdf.create([sdir,'\',sname,'.nc'],'NETCDF4');
        else
            ncid = netcdf.create([sdir,'\',sname,'.nc'],'CLOBBER');
        end
    else
        if isempty(dir(['*',sname,'*']))
            ncid = netcdf.create([sdir,'/',sname,'.nc'],'NETCDF4');
        else
            ncid = netcdf.create([sdir,'/',sname,'.nc'],'CLOBBER');
        end
    end
    cd(current)    
    
%--- build netCDF variable
    for kk = 1:numel(fds)
        %get data and variable name
            this_dat = data.(fds{kk}); %data
            this_nom = fds{kk}; %name

        %get variable size and class
            sz = size(this_dat);
            x = whos('this_dat');
                cl = x.class;
        
        if any(sz == 1)  % IF data is Nx1 array
            %Define variable dimension
                dimid = netcdf.defDim(ncid,this_nom,length(this_dat));
            %Define ID for the array variable
                dat_id(kk) = netcdf.defVar(ncid,this_nom,cl,[dimid]);
            
        else
            for ss = 1:numel(sz)
                %Define variable dimension
                    dimid(ss) = netcdf.defDim(ncid,[this_nom,'_',num2str(ss)],sz(ss));
            end
            %Define ID for the array variable
                dat_id(kk) = netcdf.defVar(ncid,this_nom,cl,[dimid]);
        end
        
        %Add variable attributes
            netcdf.putAtt(ncid,dat_id(kk),'Units',units{kk})
            netcdf.putAtt(ncid,dat_id(kk),'Full Name',long_name{kk})
            netcdf.putAtt(ncid,dat_id(kk),'Comment',comment{kk})
                
        %Add global attributes and finish defining variables
            if kk == numel(fds)    
                for gg = 1:numel(global_name)
                    glob = netcdf.getConstant('GLOBAL');
                    netcdf.putAtt(ncid,glob,global_name{gg,:},global_string{gg,:});
                end
                clear gg                
                glob = netcdf.getConstant('GLOBAL');
                netcdf.putAtt(ncid,glob,'Date Saved',datestr(now));
                netcdf.endDef(ncid);
            end
            
        clear dimid
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



