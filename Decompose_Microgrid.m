%This is the main function which calls all the subfunctions. The inputs are
%the timeseries data (one per customer), the time of day, the initial
%estimates of customer loads and labels from the survey data, and a specified
%output file name

function Decompose_Microgrid(Data,Hours,Estimates,Labels,Output_Files)
Data(Data>0.5)=Data(Data>0.5)/10;
Data=Data*1000;
N=length(Estimates);

    for i= 1:N
        Cust_Estimates=Estimates(i,:);
        Cust_Estimates(isnan(Cust_Estimates))=[];
        for j=1:length(Cust_Estimates)
            Cust_Labels{j}=Labels{i,j};
        end
        
        ESCoBox_NILM(Data(:,i),Hours(:,i),Cust_Estimates,Cust_Labels,N,Output_Files{i});
    end
end
