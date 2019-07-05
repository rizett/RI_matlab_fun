function update_progress(msg);

%-----------------------------------------------
% Updates excel file w/ progress
% 
% msg = message to write 
%-----------------------------------------------

%See how long current file is
[~,txt] = xlsread('C:\Users\Robert\ownCloud\ResearchNotes\data_processing_progress.xlsx');
current_length = size(txt,1);

%New info to write
new_write{1} = msg; %message
new_write{2} = datestr(now); %time

%Write to file
new_range = ['A',num2str(current_length+1),':B',num2str(current_length+1)];
% new_range = ['A',num2str(current_length+1)];
xlswrite('C:\Users\Robert\ownCloud\ResearchNotes\data_processing_progress.xlsx',new_write,'Sheet1',new_range)