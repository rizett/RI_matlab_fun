function saveASCII(data, long_name, units, sdir, sname,global_name,global_string,comment);

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
% Last updated: Apr. 2020
%-----------------------------------------------------------------------

%--- get all field names from data structure
    fds = fields(data);
    not_dub = zeros(size(fds));
    for kk = 1:numel(fds)
        x = data.(fds{kk});
        x = whos('x');
        cl{kk,:} = x.class;
        if ~strcmp(cl{kk,:},'double')
            not_dub(kk) = 1;
        end
    end
    %Fields w/ double data
    dub_fds = fds(not_dub == 0);
        dub_long_name = long_name(not_dub == 0);
        dub_units = units(not_dub == 0);    
    nd_fds = fds(not_dub == 1);
        nd_cl = cl(not_dub==1);
        nd_long_name = long_name(not_dub == 1);
        nd_units = units(not_dub == 1);
    
    %Sort input data/info
    [~,ii] = sort(not_dub,'descend');
        fds = fds(ii);
        cl = cl(ii);
        if exist('comment','var') 
            comment = comment(ii);
        end
        long_name = long_name(ii);
        units = units(ii);
    
%--- Open file
    if ispc
        fid = fopen([sdir '\' sname '.txt'],'wt');
    else
        fid = fopen([sdir '/' sname '.txt'],'wt');
    end

%-- Add metadata at top
    if exist('global_name','var') & exist('global_string','var')
        
        fprintf(fid,'%s\n\n','FILE INFORMATION:');

        %Global attributes
        for gg = 1:numel(global_name);
            fprintf(fid,'   %s: %s\n',global_name{gg}, global_string{gg});
        end
        fprintf(fid,'\n');
    end
    
    %Data comments
    if exist('comment','var')        
        fprintf(fid,'%s\n\n','DATA COMMENTS:');
        for ff = 1:numel(fds)
            fprintf(fid,'   %s: %s\n',long_name{ff,:}, comment{ff});
        end
        fprintf(fid,'\n');
    end

%--- go through each field of double data and extract data
dat = [];
headers = {};
for kk = 1:numel(dub_fds)
    dat_here = data.(dub_fds{(kk)});
    
    %reshape data into columns if necessary
        s = size(dat_here);
        
        if s(2)>s(1)
            dat_here = reshape(dat_here,s(2),s(1));
        end; clear s

    if kk>1 & length(dat_here)<length(dat(:,kk-1))
        dat_here(end+1:length(dat(:,kk-1))) = nan(1,length(dat(:,kk-1))-length(dat_here));
    end
        
    %make header
        head = [dub_long_name{(kk)} ' [' dub_units{(kk)} ']'];
        
    %add to data matrix
        dat = [dat, dat_here]; clear dat_here
        headers = [headers, head]; clear head
        
end

%--- make headers for non-double data/info
    nd_head = [];
    for kk = 1:numel(nd_fds)
        nd_head = [nd_head, [nd_long_name{kk}, ' [', nd_units{kk} ']']];
    end
    headers = [nd_head,headers];
    
%--- write data to file
    fprintf(fid,'DATA:\n');
    fprintf(fid,'\n');
    fprintf(fid,[repmat('%s,',1,length(headers(1,:))-1),'%s\n'],headers{:});
    
    %make input sequence string
        seq = [repmat('%s,',1,numel(nd_fds)), repmat('%0.3f,',1,numel(dub_fds))];
        seq = seq(1:end-1); seq = [seq,'\n'];
    
    for kk = 1:size(dat,1)
        %get non-double data to write
        if ~isempty(nd_fds)
            inp = [];
            for nn = 1:numel(nd_fds)
                inp = [inp,'strtrim(char(data.(nd_fds{nn})(kk,:))),'];
            end
            fprintf(fid,seq,eval(inp),dat(kk,:));
        else
            fprintf(fid,seq,dat(kk,:));
        end
    end
    
    fclose(fid);

end