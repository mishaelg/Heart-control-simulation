function E=EN(Emax,Ed,tmax,dt,N)
endsys=floor(2*tmax/dt);
En(1:endsys)=0.5*(1+sin(2*pi*(1:endsys)/endsys-pi/2));  %normalized LV elasticity
En(endsys+1:N)=0;
E=max(Ed,Emax*En);
