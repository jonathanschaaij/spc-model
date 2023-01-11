% This script plot the Lithium Battery Charging plot
% Version 1.00 Aug 2019

% Plot Battery State of Charge
subplot(3,1,1);
plot(simout(:,1),'linewidth',2,'Color','y');
xlim([0 length(simout)]);
ylim([0 110]);
ylabel('SOC (%)');
title('Lithium Battery Charging Plot');
% Plot Battery Voltage
subplot(3,1,2);
plot(simout(:,3),'linewidth',2,'Color','b');
xlim([0 length(simout)]);
ylabel('Voltage (V)');
% Plot Battery Current
subplot(3,1,3);
plot(simout(:,2)*-1,'linewidth',2,'Color','r');
text(60,max(simout(:,2)*-1)-0.5,'CC Charge');
if min(simout(:,2)*-1)<0.5
    text(find(simout(:,2)*-1<=0.5,1),max(simout(:,2)*-1)-0.5,'CV Charge');
end
xlim([0 length(simout)]);
ylabel('Current (A)');
xlabel('Time (sec)');