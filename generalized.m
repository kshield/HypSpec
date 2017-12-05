function Y=generalized(filename, concentrations)

%filename in ' .txt' form
%concentrations in [ ] form; space delimited
%% Importing
% Import the data somehow, magically.
% Save as "XXXX" (where X = C (CAM) or H (HOPO)

filename = 'Desktop/Berkeley/Abergel Group/Data/20160922CHHC2.txt';
delimiter = '\t';

A = importdata(filename,delimiter);

data = dlmread(filename,delimiter,1,0);

titles = [0, 1, 2, dlmread(filename,delimiter,[0,3,0,size(A.data,2)])];

fulldata = cat(1, titles, data);

%% corrections

%volume - adjusting for incorrect initial volume of 0.02 instead of 0.00
fulldata(2:end,2) = fulldata(2:end,2)-0.02;

%pH - correcting the fact that the first data point's pH is a holdover from
%the last time the software was run. adjusting to have same difference as
%the next pH change.
fulldata(2,3) = fulldata(3,3)-(fulldata(4,3)-fulldata(3,3));

%% id
% Isolate the points (column one) as a matrix called "id" [0]
% Transpose
% Doesn't keep the header
id = fulldata(2:end,1)';
% % str2num(id{1})
% XXXX(2:end,1)';



%% pH
% Isolate the pH (column three); call it "pH" 
% Transpose
% Doesn't keep the header
pH=fulldata(2:end,3)';


%% Create a path row "path" [1] 
% = 1cm unless otherwise noted
path=ones(1,size(fulldata,1)-1); 


%% Create the Concentration matrix [2]
% N = nargin;
% %c = length(varargin);
% 
% if N = 1
%          conc = zeros(1,size(fulldata,1)) + varargin{1};
% elseif N = 3
%         conc = [zeros(1,size(fulldata,1)) + varargin{1}; zeros(1,size(fulldata,1)) + varargin{2}];
% elseif N = 4 
%         conc = [zeros(1,size(fulldata,1)) + varargin{1}; zeros(1,size(fulldata,1)) + varargin{2}; zeros(1,size(fulldata,1)) + varargin{3}];
% end

conc1 = zeros(length(concentrations),size(fulldata,1));
% 
% conc1 = conc(1,:);
% %varargin{k}
% 
% for k = 1:c
%     conc(k,:) = varargin{k};
%     
% end 

for i = 1:length(concentrations)
    conc(i,:) = concentrations(i);
end

%conc = zeros(length(varargin),size(fulldata,1))

%for varargin{i}
 %   conc(i,:) = varargin(i)
%end

%% Create the wavelength matrix
wavelength=fulldata(:,4:end)';


%% Combine into one Matrix
dataexport=[0 id;1 path;conc;3 pH; wavelength];
%and additional concentrations as appropriate%


%% Get rid of the bottom crap
for i = 0:length(dataexport)
    j = length(dataexport);
    
    if any(isnan(dataexport(j, :)))
        dataexport(j,:)=[];

    elseif all(dataexport(j,:))== 0
         dataexport(j,:)=[];

    else 
        break
    end
    
end


%%conc = zeros(length(concentrations),size(fulldata,1));

% 
% minimum = dataexport(5:end,2:end);
% minimum = min(minimum,[],1);
% 

%% Adjust values from minimum

minimum = dataexport(5:end,2:end); %5 here & everywhere else needs to be replaced with the # rows of the conc matrix + 3
%has to be dataexport matrix b/c lost the random stuff at the bottom
minimum2 = min(minimum,[],1);
dataexport2 = zeros(size(dataexport,1), size(dataexport,2));

for j = 2:size(dataexport2,2)
    dataexport2(5:end,j) = dataexport(5:end,j) - minimum2(1,j-1);   
        %dataexport(5:end,2:end) = dataexport(5:end,2:end)- minimum(i);
   
end
dataexport2(:,1)=dataexport(:,1);
dataexport2(1:4,:)=dataexport(1:4,:);


%% Saving the file
% Y=dataexport2;
% saveas = sprintf('%s_out.txt', filename);
% dlmwrite(saveas, Y,' ');
% %Problem ^ this overwrites the original file%
% 
% 

end

