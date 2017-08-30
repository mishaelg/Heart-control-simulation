clear all 
close all
% time scale parameters
HR=80;                  % BPM
tmax=0.350;
dt=0.5e-3;              %sec
NN=floor(60/(40*dt));   % largest possible vector size for lowest HR - 40
N=floor(60/(HR*dt));    %number of points per heart cycle for HR=80
m_end=1;
% heart model parameters 
Emax=2.0;
Vo=15;
%vascular parameters
Ra=0.1;                 % arterial resistance - series
Rp=1.0;                 % peripheral resistance
Rv=0.01;                % venous filling resistance
Ca=2.0;                 % arterial compliance
Cv=300;
Ed=0.08;              % heart diastolic elasticity 
% initialization  of variables
Plv(1:NN)=0;          % left ventricular pressure
Vlv(1:NN)=120;        % left ventricular volume
Qlv(1:NN)=0;          % left ventricular outflow
Pa(1:NN)=70;          % pressure on arterial capacitor
Va(1:NN)=270;         % volume on arterial capacitor
Qp(1:NN)=0;           % flow in peripheral resistance
Pv(1:NN)=9;           % venous filling pressure
Vv(1:NN)=2400;        % venous volume
Qv(1:NN)=0;           % ventricular filling inflow

Tcycles=20;             % total heart cycles

for cycle=1:Tcycles
    tmax=0.5-0.0025*HR;
    E=EN(Emax,Ed,tmax,dt,N); %calculates E for the whole heart cycle

    % main loop for each time step
    for i=2:N
        Vlv(i)=Vlv(i-1)+(Qv(i-1)-Qlv(i-1))*dt;
        Va(i)=Va(i-1)+(Qlv(i-1)-Qp(i-1))*dt;
        Vv(i)=Vv(i-1)+(Qp(i-1)-Qv(i-1))*dt;
        Plv(i)=E(i)*(Vlv(i)-Vo);
        Pa(i)=Va(i)/Ca;
        Pv(i)=Vv(i)/Cv;
        Qv(i)=max(0,(Pv(i)-Plv(i))/Rv);
        Qlv(i)=max(0,(Plv(i)-Pa(i))/Ra);
        Qp(i)=Pa(i)/Rp; 
        Pao(i)=Pa(i)+Qlv(i)*Ra;
    end;
    % monitored variables for plotting 
    if cycle>Tcycles-5
        m_Plv(m_end:m_end+N-1)=Plv(1:N);  
        m_Vlv(m_end:m_end+N-1)=Vlv(1:N);
        m_Qlv(m_end:m_end+N-1)=Qlv(1:N);
        m_Pao(m_end:m_end+N-1)=Pao(1:N); 
        m_end=length(m_Plv); % end of var needed to append new data
    end;
    % cycling variables
    Plv(1)=Plv(N);
    Vlv(1)=Vlv(N);
    Qlv(1)=Qlv(N);
    Pa(1)=Pa(N);
    Pao(1)=Pao(N);
    Va(1)=Va(N);
    Qp(1)=Qp(N);
    Pv(1)=Pv(N);
    Qv(1)=Qv(N);
    Vv(1)=Vv(N);
end;

% PID - This can only run once, in order to run again plase run the above code first

Pao_rest=82.52;
error=0;
n=100;

HR_rest=80;
HRi=0;
HRd=0;
HRp=0;


v=struct('Plv',0,'Vlv',120,'Qlv',0,'Pa',70,'Va',270,'Qp',0,'Vv',2700,'Qv',0,'Pv',9,'Pao',82.52);

%PID K values
Ki=5.6;
Kd=1.8;
Kp=4.5;

% Initialize vectors
Pao_mean=zeros(1,n);
HR_graph=zeros(1,n);
Rp_graph=zeros(1,n);

for i=1:n
    if i<20 % At rest
    [Pao_mean(i),v]=cvs(v,HR,Emax,Cv,Rp);
   
    HR_graph(i)=HR;
    Rp_graph(i)=Rp;
    else
       Rp=0.8;
       [Pao_mean(i),v]=cvs(v,HR,Emax,Cv,Rp);   
       error_old=error;
       error=Pao_rest-Pao_mean(i);
       HRp=error*Kp;
       HRd=(error-error_old)*Kd;
       HRi= HRi+error*Ki;
       HR=HRp+HRd+HRi+HR_rest;
      
       HR_graph(i)=HR;
       Rp_graph(i)=Rp;
    end
end

%

subplot(3,1,1)
plot(1:n,Rp_graph,'r');
title('Peripheral resistance as function of Heart cycles');
ylabel('Rp')
xlabel('Heart cycles')


subplot(3,1,2)
plot(1:n,Pao_mean,'g');
title('Aortic pressure as function of Heart cycles');
ylabel('pressure [mmHg]')%make sure these are relevant...
xlabel('Heart cycles') %want to check this! i dont think it's cycle... sth else!

subplot(3,1,3)
plot(1:n,HR_graph,'b');
title('Heart Rate as function of Heart cycles ');
ylabel('HR [beats/min]')
xlabel('Heart cycles')
% end