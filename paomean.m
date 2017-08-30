
clear all; clc;
%initialize
HR=80;
Cv=300; 
Rp=1.0; 
Emax=2.0;
Tcycles = 20; 
samples=50;
j=0;

%initialize vectors
vecHR=linspace(0.5*HR,2*HR,samples);
vecEmax=linspace(0.5*Emax,2*Emax,samples);
vecCv=linspace(0.5*Cv,2*Cv,samples);
vecRp=linspace(0.5*Rp,2*Rp,samples);
X=linspace(0.5,2,samples);
%
Pao_mean_HR(samples)=0;
Pao_mean_Cv(samples)=0;
Pao_mean_Rp(samples)=0;
Pao_mean_Emax(samples)=0;


%for loops to get pao mean for each new HR/emax/rp/cv new value

for i=1:samples
    v=struct('Plv',0,'Vlv',120,'Qlv',0,'Pa',70,'Va',270,'Qp',0,'Vv',2700,'Qv',0,'Pv',9,'Pao',82.52);
    for j=1:Tcycles 
    [Pao_mean_HR(i),v]=cvs(v,vecHR(i),Emax,Cv,Rp);
    
   end
end
for i=1:samples
    v=struct('Plv',0,'Vlv',120,'Qlv',0,'Pa',70,'Va',270,'Qp',0,'Vv',2700,'Qv',0,'Pv',9,'Pao',82.52);
    for j=1:Tcycles 
    [Pao_mean_Cv(i),v]=cvs(v,HR,Emax,vecCv(i),Rp);
    
   end
end
for i=1:samples
    v=struct('Plv',0,'Vlv',120,'Qlv',0,'Pa',70,'Va',270,'Qp',0,'Vv',2700,'Qv',0,'Pv',9,'Pao',82.52);
    for j=1:Tcycles 
   [ Pao_mean_Emax(i),v]=cvs(v,HR,vecEmax(i),Cv,Rp);
    
   end
end
for i=1:samples
    v=struct('Plv',0,'Vlv',120,'Qlv',0,'Pa',70,'Va',270,'Qp',0,'Vv',2700,'Qv',0,'Pv',9,'Pao',82.52);
    for j=1:Tcycles 
   [ Pao_mean_Rp(i),v]=cvs(v,HR,Emax,Cv,vecRp(i));
    
   end
end

for i=1:samples
 Pao_mean_HR(i)=Pao_mean_HR(i)/82.52;
 Pao_mean_Emax(i)=Pao_mean_Emax(i)/82.52;
 Pao_mean_Cv(i)=Pao_mean_Cv(i)/82.52;
 Pao_mean_Rp(i)=Pao_mean_Rp(i)/82.52;
end

plot (X,Pao_mean_HR,'g')
hold on
plot (X, Pao_mean_Rp,'r')
hold on
plot(X, Pao_mean_Cv,'k')
hold on
plot(X, Pao_mean_Emax,'b')
title('Sensitivity of aortic pressure to change in parameters');
xlabel('Change in parameters value');
ylabel('Aortic pressure value');
legend('HR','Rp','Cv','Emax'); 