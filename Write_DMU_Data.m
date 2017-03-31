%This function writes the output from the disaggregation and identification
%algorithms into a CSV file with headers for the appliance, each hour of
%the day, and the estimated power of the appliance.

function Write_DMU_Data(Appliance_Hours,Appliance_Powers,Appliance_Labels,Filename)
fid = fopen(Filename, 'w') ;
fprintf(fid, 'Appliances,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,Power (W)\n') ;
fclose(fid);

for i=1:length(Appliance_Powers)
fid = fopen(Filename, 'a') ;
fprintf(fid, Appliance_Labels{i});
fclose(fid);    
dlmwrite(Filename,[Appliance_Hours(i,:) Appliance_Powers(i)],'-append',...
    'delimiter',',','coffset',1)
end

end