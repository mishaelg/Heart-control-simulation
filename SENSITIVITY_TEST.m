HR=80;
tmax=0.5-0.0025*HR;
dt=0.5e-3;              %sec
N=floor(60/(HR*dt));    %number of points per heart cycle for HR=80

% heart model parameters 
Vo=15;
Emax=2.0;
%vascular parameters
Ra=0.1;                 % arterial resistance - series
Rp=1.0;                 % peripheral resistance
Rv=0.01;                % venous filling resistance
Ca=2.0;                 % arterial compliance
Ed=0.0666;              % heart diastolic elasticity 
Cv=300;

Tcycles=20;             % total heart cycles   
mPaoHR(1:19)=0;
mPaoEmax(1:19)=0;
mPaoRp(1:19)=0;
mPaoCv(1:19)=0;
v=struct ('Plv',0,'Vlv',120,'Qlv',0,'Pa',70,'Va',270,'Qp',0,'Pv',9,'Qv',0,'Vv',2700,'Pao',0);
vR=struct ('Plv',0,'Vlv',120,'Qlv',0,'Pa',70,'Va',270,'Qp',0,'Pv',9,'Qv',0,'Vv',2700,'Pao',0);
  for cycle=1:Tcycles
 [mPaoR,vR]=cvs(Emax,vR,HR,Cv,Rp);
  end
  
for j=1:4
    for i=1:19
        a(i)=0.5+(i-1)/12;
        switch j
            case 1
                for cycle=1:Tcycles
                    [mPaoHR(i),v]=cvs(Emax,v,a(i)*HR,Cv,Rp);
                end
              
            case 2
                for cycle=1:Tcycles
                    [mPaoEmax(i),v]=cvs(a(i)*Emax,v,HR,Cv,Rp);
                end
            case 3
                for cycle=1:Tcycles
                    [mPaoRp(i),v]=cvs(Emax,v,HR,Cv,a(i)*Rp);
                end
            case 4
                for cycle=1:Tcycles
                  
                   [mPaoCv(i),v]=cvs(Emax,v,HR,a(i)*Cv,Rp);
                end
             end 
        
    end 
end
a=1:19;
figure;
plot(a/7,mPaoHR/mPaoR,'r');
hold on;
plot(a/7,mPaoEmax/mPaoR,'b');
hold on;
plot(a/7,mPaoRp/mPaoR,'m');
hold on;
plot(a/7,mPaoCv/mPaoR,'c');
title('Paomean(a)');
xlabel('normalized factor a');
ylabel('mPao/mPaoRest');
legend('PaoHR','PaoEmax','PaoRp','PaoCv');


                    

