function Y=generalized(filename, concentrations)
%filename in 'C:/Users/kathe/Desktop/Berkeley/AbergelGroup/Data/20160922CHHC2.txt' form
%concentrations in [ ] form; space delimited
%% Importing
% Save as "XXXX" (where X = C (CAM) or H (HOPO)
filename = 'C:/Users/kathe/Desktop/Berkeley/AbergelGroup/Data/20160922CHHC2.txt';
concentrations = [2.5E-5];
delimiter = '\t';

A = importdata(filename,delimiter);

data = dlmread(filename,delimiter,1,0);

titles = [0, 1, 2, dlmread(filename,delimiter,[0,3,0,size(A.data,2)])];

fulldata = cat(1, titles, data);

%% corrections

%VOLUME - 
% adjusting for incorrect initial volume of 0.02 instead of 0.00
fulldata(2:end,2) = fulldata(2:end,2)-0.02;

%pH - 
% correcting the fact that the first data point's pH is a holdover from
% the last time the software was run. adjusting to have same difference as
% the next pH change.
fulldata(2,3) = fulldata(3,3)-(fulldata(4,3)-fulldata(3,3));

%% id
id = fulldata(2:end,1)';
% Isolate the points (column one) as a matrix called "id" [0]
% Transpose
% Doesn't keep the header
%% pH
pH=fulldata(2:end,3)';
% Isolate the pH (column three); call it "pH" 
% Transpose
% Doesn't keep the header
%% Create a path row "path" [1] 
path = ones(1,size(fulldata,1)-1); 
% = 1cm unless otherwise noted
% IF NOT 1CM:
% path = zeros(1,size(fulldata,1)-1) + PATHLENGTH IN CM;
%% Create the Concentration matrix [2]

conc1 = zeros(length(concentrations),size(fulldata,1));
% matrix of size: 
% # of rows = # of entries in the concentrations vector
% # of columns = width of fulldata matrix; 
for i = 1:length(concentrations)
    conc1(i,:) = concentrations(i);
end
%% Create the wavelength matrix
wavelength=fulldata(:,4:end)';
% vast majority of the data; all the wavelengths & associated data points
%% Combine into one Matrix
dataexport=[0 id;1 path;conc1;3 pH; wavelength];
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
%% Adjust values from minimum
minmat = dataexport(size(conc1,1)+4:end,2:end); 
% has to be dataexport matrix b/c lost the random stuff at the bottom
% minimums matrix of the size of the cleaned up 
mins = min(minmat,[],1);
finaldata = zeros(size(dataexport,1), size(dataexport,2));

for j = 2:size(finaldata,2)
    finaldata(size(conc1,1)+4:end,j) = dataexport(size(conc1,1)+4:end,j) - mins(1,j-1);   
        %dataexport(5:end,2:end) = dataexport(5:end,2:end)- minimum(i);
end

for k = 1:size(conc1,1)+3
    finaldata(k,:) = dataexport(k,:);    
end    
finaldata(:,1)=dataexport(:,1);

%% Saving the file
Y=finaldata;
saveas = sprintf('%s_out.txt', filename);
dlmwrite(saveas, Y,' ');

%% plot a single pH
% figure
% for i = length(concentrations)+4:size(finaldata,1)
%    x = finaldata(i,1);
%    y = finaldata(i,2);
%    plot(x,y,'.','Color',[0,0,i/1000])
%    hold on
% end
% 
% hold off

% %% plot a single wavelength
% figure
% for i = 2:size(finaldata,2)
%    x = finaldata(6,1);
%    y = finaldata(6,i);
%    plot(x,y,'.')
%    hold on
% end
% 
% hold off
% %% plot take two :
% figure
% for i = length(concentrations)+4:size(finaldata,1)
%    x = finaldata(i,1)
%   % y = dataexport(i,2:end);
% %   plot(x,y,'.','Color',[0,0,j/1000])
%   % scatter(x,y)
%    for j = 2:size(finaldata,2)
%       y = finaldata(i,j)
%       plot(x,y,'.','Color',[0,0,j/1000])
%       hold on
%    end
% 
% end
% 
% hold off

%% absorbance plot data
absorbance = finaldata(size(concentrations)+4:end,:);
%% plot take three?
figure
plot(absorbance(:,1),absorbance(:,2:end))

%% plot a single wavelength
figure
for i = 2:size(finaldata,2)
      for j = length(concentrations)+4:size(finaldata,1)
   x = finaldata(j,1);
   y = finaldata(j,i);
   
  
      end
     
 
end
    plot(x,y,'.','Color',[i/200,0.4,cos(i/100)])


end

