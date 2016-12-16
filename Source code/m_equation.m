function y = m_equation(x,eta,Alpha,yp,Vm,Km,P1,P2,P3,P4,Ta)


S = @(x,P1,P2,P3,P4) (P1 +P2/ (1 + exp(-(log10(x)+P3)/P4)));

y = zeros(1,17);

%% Concentrations

% Orexin-A release and reuptake dynamics in DRN(estimated with simplest equation)
y(1) = Alpha(1)*x(10) - eta(1)*x(1);

% Orexin-B release and reuptake dynamics in DRN(estimated with simplest equation)
y(2) = Alpha(2)*x(10) - eta(2)*x(2);

%Norepinephrine release and reuptake dynamics in DRN (Mitchell et al 1994)
y(3) = yp(3)*x(17) - (Vm(3)*x(3))/(Km(3)+x(3));

% Orexin release and reuptake dynamics in LC(estimated with simplest equation)
y(4) = Alpha(4)*x(10) - eta(4)*x(4);

%Serotonin release and reuptake dynamics in LC (Bunin et al. 1998)
y(5) = yp(5)*x(14) - (Vm(5)*x(5))/(Km(5)+x(5));

%Serotonin release and reuptake dynamics in LHA (Bunin et al. 1998)
y(6) = yp(6)*x(14) - (Vm(6)*x(6))/(Km(6)+x(6));

%Norepinephrine release and reuptake dynamics in LHA (Mitchell et al 1994)
y(7) = yp(7)*x(17) - (Vm(7)*x(7))/(Km(7)+x(7));

%% Incoming currents to LHA

% Input-output function for 5-HT induced curent on LHA neurons
% 5-HT induced current on LHA neurons
y(8) = Ta(8)*(-x(8)+ S(x(6),P1(8),P2(8),P3(8),P4(8)));

% Input-output function for Ne induced curent on LHA neurons
y(9) = Ta(9)*(-x(9)+ S(x(7),P1(9),P2(9),P3(9),P4(9)));
% Ne induced current on LHA neurons

%% Incoming currents to DRN

% Input-output function for Ox induced curent on DRN neurons
y(11) = Ta(11)*(-x(11)+ S(x(1),P1(11),P2(11),P3(11),P4(11)));
% Ox induced current on DRN neurons

% Input-output function for Ox induced curent on DRN neurons
y(12) = Ta(12)*(-x(12)+ S(x(2),P1(12),P2(12),P3(12),P4(12)));
% Ox induced current on DRN neurons

% Input-output function for Ne induced curent on DRN neurons
y(13) = Ta(13)*(-x(13)+ S(x(3),P1(13),P2(13),P3(13),P4(13)));
% Ne induced current on DRN neurons

%% Incoming currents to LC

% Input-output function for Ox induced curent on LC neurons % control
y(15) = Ta(15)*(-x(15)+ S(x(4),P1(15),P2(15),P3(15),P4(15)));
% Ox induced current on LC neurons

% Input-output function for Ser induced curent on LC neurons
y(16) = Ta(16)*(-x(16)+ S(x(5),P1(16),P2(16),P3(16),P4(16)));
% Ser induced current on LC neurons

end