function [Pao_mean,v]=cvs(v,HR,Emax,Cv,Rp)

dt=0.5e-3;  
N=floor(60/(HR*dt));  %samples on each cycle
%vascular parameters
Vo=15; 
Ra=0.1;                 % arterial resistance - series
Rv=0.01;                % venous filling resistance
Ca=2.0;                 % arterial compliance
Ed=0.0667;              % heart diastolic elasticity 

%initialization  of variables
Plv(1:N)=v.Plv;        % left ventricular pressure
Vlv(1:N)=v.Vlv;        % left ventricular volume
Qlv(1:N)=v.Qlv;        % left ventricular outflow
Pa(1:N)=v.Pa;          % pressure on arterial capacitor
Va(1:N)=v.Va;          % volume on arterial capacitor
Qp(1:N)=v.Qp;          % flow in peripheral resistance
Vv(1:N)=v.Vv;          % volume on venous capacitor
Qv(1:N)=v.Qv;          % ventricular filling inflow
Pv(1:N)=v.Pv;          % venous filling pressure
Pao(1:N)=v.Pao;        %reseting Pao from the starting variables

tmax=0.5-0.0025*HR;
E=EN(Emax,Ed,tmax,dt,N);

  for i=2:N
        Vlv(i)=Vlv(i-1)+(Qv(i-1)-Qlv(i-1))*dt;%all volumes
        Va(i)=Va(i-1)+(Qlv(i-1)-Qp(i-1))*dt;
        Vv(i)=Vv(i-1)+(Qp(i-1)-Qv(i-1))*dt;
        
        Pa(i)=Va(i)/Ca; % all pressures
        Pv(i)=Vv(i)/Cv;
        Plv(i)=E(i)*(Vlv(i)-Vo); %%changed this according to reference!! without Emax*Ei
        
        Qp(i)= Pa(i)/Rp; % no Diode, flow can go both ways %% changed this according to other reference!
        Qlv(i)=max((Plv(i)-Pa(i))/Ra,0); % due to Diode, we force the flow to go in one direction only
        Qv(i)=max((Pv(i)-Plv(i))/Rv,0); % due to Diode, we force the flow to go in one direction only
        
        Pao(i)=Pa(i)+Qlv(i)*Ra; %  pao calculation for pao_mean
      
      
    
      
    
       
      

    
 
        
        
        
   end;
    
   %refreshing the values for the next calculation
    v.Plv=Plv(N);
    v.Vlv=Vlv(N);
    v.Qlv=Qlv(N);
    v.Pa=Pa(N);
    v.Va=Va(N);
    v.Qp=Qp(N);
    v.Pv=Pv(N);
    v.Vv=Vv(N);
    v.Qv=Qv(N);
    v.Pao=Pao(N);

    Pao_mean = mean(Pao(i:N));


end