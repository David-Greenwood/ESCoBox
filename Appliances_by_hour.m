% This function enumerates how often each appliance was one during a given
% hour of the day, and calculates the probability the appliance will be
% turned on during that hour

function [Statecount,Probs]=Appliances_by_hour(Appliance_Switching,Hours)
Nappliances=size(Appliance_Switching,1);
Statecount=zeros(Nappliances,24);
Probs=zeros(Nappliances,24);
Hourcount=zeros(24,1);


for i=0:23
    ind=find(Hours==i);
    Hourcount(i+1)=length(ind);
    for j=1:Nappliances
        Statecount(j,i+1)=sum(Appliance_Switching(j,ind));
        Probs(j,i+1)=Statecount(j,i+1)/Hourcount(i+1);
    end
end

end