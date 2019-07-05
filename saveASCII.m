function saveASCII(data, long_name, units, sdir, sname);

%-----------------------------------------------------------------------
% Save array data from matlab structure to ASCII (.txt) format:
%
% Usage: saveASCII(data, long_name, units, dir)
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
% saves ASCII data file to specified save directory - have a look!! :)
%
% R. Izett (rizett@eoas.ubc.ca)
% UBC, Oceanography
% Last updated: Jan. 2018
%-----------------------------------------------------------------------

%--- get all field names from data structure
fds = fields(data);

dat = [];
headers = {};

%--- go through each field of double data and extract data
for kk = 1:numel(fds)
    dat_here = data.(fds{(kk)});
    
    %reshape data into columns if necessary
        s = size(dat_here);
        
        if s(2)>s(1)
            dat_here = reshape(dat_here,s(2),s(1));
        end; clear s

    if kk>1 & length(dat_here)<length(dat(:,kk-1))
        dat_here(end+1:length(dat(:,kk-1))) = nan(1,length(dat(:,kk-1))-length(dat_here));
    end
        
    %make header
        head = [long_name{(kk)} ' [' units{(kk)} ']'];
        
    %add to data matrix
        dat = [dat, dat_here]; clear dat_here
        headers = [headers, head]; clear head
        
end

%save
    fid = fopen([sdir '\' sname '.txt'],'wt');
    fprintf(fid,[repmat('%s,',1,length(headers(1,:))-1),'%s\n'],headers{:});
    seq = [repmat('%0.3f,',1,length(dat(1,:)))]; seq = seq(1:end-1); seq = [seq,'\n'];
    for kk = 1:length(dat)
        fprintf(fid,seq,dat(kk,:));
    end
    fclose(fid);

end