function Decomposed_Data=ESCoBox_NILM(Demand_Data,Hours,Appliance_Power_Estimates,Appliance_Names,N,Data_File)

%Set up HSMM Problem
%Reduce state-space for large simulations
% if length(Appliance_Power_Estimates)>5
 M=2^(length(Appliance_Power_Estimates)-1);
% else
M=2^length(Appliance_Power_Estimates);
% end

D=floor(length(Demand_Data)/4);

%Round demand data to nearest watt
MO=round(Demand_Data,2);
[A,B,P,PAI,Vk,O,K]=hsmmInitializeESC(MO,M,D,Appliance_Power_Estimates);

%Run HSMM
[A,B,PAI,P,Stateseq,Loglikelihood]=hsmm_m(PAI,A,B,P,O,N,D);

%Identify States
[Appliance_Seq,Appliance_Onoff,Labels,Appliance_Final_Powers,Appliance_Seq_Plot]=Identify_States(Stateseq,B,Vk,Appliance_Power_Estimates, Appliance_Names);
% 
% j=1;
% Updated_A=A;
% for i=unique(Appliance_Seq)
%     States=unique(Stateseq(Appliance_Seq==i));
%     Updated_B(j,:)=mean(B(States,:));
%     Updated_PAI(j)=sum(PAI(States));
%     Updated_P(j,:)=mean(P(States,:));
%     Updated_A=Merge_States(Updated_A,States,PAI)
%     j=j+1;
% end    


    
%figure
%Hourly_States=States_by_hour(Appliance_Seq_Plot,Hours,Labels);

%Calculate appliance usage by hour
[Appliance_Hours,Probs]=Appliances_by_hour(Appliance_Onoff,Hours,Appliance_Names);
Write_DMU_Data(Probs,Appliance_Final_Powers,Appliance_Names,Data_File)

% Decomposed_Data.State_Seq=Stateseq;
% Decomposed_Data.Appliance_Seq=Appliance_Seq;
% Decomposed_Data.Hourly_States=Hourly_States;
% Decomposed_Data.Appliance_Hours=Appliance_Hours;
% Decomposed_Data.Trans_Matrix=A;
% Decomposed_Data.Emiss_Matrix=B;
% Decomposed_Data.State_Labels=Labels;
% Decomposed_Data.Appliance_Powers=Appliance_Final_Powers;
% Decomposed_Data.Appliance_Switching=Appliance_Onoff;
% Decomposed_Data.LogLikelihood=Loglikelihood;
% Decomposed_Data.Power_Readings=Vk;
% Decomposed_Data.Dur_Mat=P;

end