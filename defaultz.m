function defaultz(fntsz)

%--------------------
%Set default values
%--------------------

if ~exist('fntsz','var') 
    fntsz = 10.5;
end

set(0,'defaultAxesFontName','Gill Sans MT'); %font type
set(0,'defaultTextFontName','Gill Sans MT'); %font type
set(groot, 'FixedWidthFontName','Gill Sans MT')
set(0,'defaultaxesfontsize',fntsz); %font size
set(groot, 'defaultFigurePosition',[750 200 560 420]) %figure position

