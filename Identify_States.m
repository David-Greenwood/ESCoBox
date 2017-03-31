function [Appliance_Seq,Appliance_Onoff,Labels,Appliance_Final_Powers,Appliance_Seq_Plot]=Identify_States(Stateseq,Power_probs,Power_Indeces,Appliance_Powers, Appliance_Names)

%This loop determines state median power consumption
Nstates=max(Stateseq);
State_Loads=zeros(Nstates,1);

%This loop computes the likely combinations of appliance powers
Nappliances=length(Appliance_Powers);
Appliance_Comb=zeros(2^Nappliances,Nappliances);

%Create table of on/off states
for i=1:Nappliances
    A=1;
    B=0;
    for j=1:2^Nappliances
       if  A<2^(i-1);
           Appliance_Comb(j,i)=B;
           A=A+1;
       else
           Appliance_Comb(j,i)=B;
           A=1;
           if B==0
               B=1;
           else
               B=0;
           end
       end
    end
end
options=optimset('MaxIter',1000000,'MaxFunEvals',1000000);
[Appliance_Powers,fval,exitflag,output]=fmincon(@(x) Fit_States(x,Power_probs,Power_Indeces,Nstates,Appliance_Comb), Appliance_Powers,[],[],[],[],zeros(1,length(Appliance_Powers)),[],[],options);

%Create aggregate power from on/off states
Appliance_Comb_Powers=Appliance_Comb*Appliance_Powers';


%Create probability-weighted difference terms
    for i=1:Nstates
        for j=1:2^Nappliances
            Diffs(i,j)=sum(abs(Power_probs(i,:).*(Power_Indeces'-Appliance_Comb_Powers(j))));
        end
    [Diff,Closest_State]=min(Diffs(i,:));
    State_Index(i)=Closest_State;
    Min_Diffs(i)=Diffs(i,Closest_State);    
    end
    
    %Create a sequence of appliance states
for i=1:length(Stateseq)
    Appliance_Seq(i)=State_Index(Stateseq(i));
end

%Create an on/off vector for each appliance
Appliance_Onoff=zeros(Nappliances,length(Stateseq));
State_Combs=unique(Appliance_Seq);
for i=1:length(Stateseq)
    for j=1:Nappliances
        Appliance_Onoff(j,i)= Appliance_Comb(Appliance_Seq(i),j);
    end
end
%Label each appliance state combination
State_Combs=unique(Appliance_Seq);
for i=1:length(State_Combs)
    Label={};
    k=1;
    for j=1:Nappliances
        if Appliance_Comb(State_Combs(i),j)==1
            Label{k}=Appliance_Names{j};
            k=k+1;
        end
    end
    if k==1
        Labels{i}='None';
    else
        Labels{i}=strjoin(Label);
    end
end

% subplot(2,1,1)
 k=1;
 Appliance_Seq_Plot=Appliance_Seq;
 for i=unique(Appliance_Seq)
     ind=find(Appliance_Seq_Plot==i);
     Appliance_Seq_Plot(ind)=k;
     k=k+1;
 end

 Appliance_Final_Powers=Appliance_Powers;
end

function [Min_Diffs]=Fit_States(Appliance_Powers,Power_probs,Power_Indeces,Nstates,Appliance_Comb)

%This loop computes the likely combinations of appliance powers
Nappliances=length(Appliance_Powers);

%Create aggregate power from on/off states
Appliance_Comb_Powers=Appliance_Comb*Appliance_Powers';

%Create probability-weighted difference terms
    for i=1:Nstates
        for j=1:2^Nappliances
            Diffs(i,j)=sum(abs(Power_probs(i,:).*(Power_Indeces'-Appliance_Comb_Powers(j))));
        end
    [Diff,Closest_State]=min(Diffs(i,:));
    State_Index(i)=Closest_State;
    Min_Diffs(i)=Diffs(i,Closest_State);    
    end
    Min_Diffs=sum(Min_Diffs);
end

    