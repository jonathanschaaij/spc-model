% Author: Tjeerd Bakker, Jonathan Schaaij, Alexandru Savca 
clear;
close all;
clc;

%% Constant
airDensity = 1.293;% kg/m^3
gravity = 9.81; %m/s^2

%% Design tunable
aeroDragCoeff = 0.18;
rollingResistCoeff = 0.008;
frontArea = 3; %m^2

regen_efficency = 1; % 
motor_gear_ratio = 7; %    
towing_ratio = 1 ; % how much does the caravan pull itself

massCaravan = 250; % kg 
massStorage = 200; % kg

nTires = 2;
massTire = 20; %kg
radiusTire = 0.3; %m    

%% Motor params
rated_speed = 25000; %rpm
rated_load = 250; %kW

%% Battery param
battery_low_cut_off = 5; % at XX% battery charge the simulation will stop
battery_high_cut_off = 95
NominalVoltage = 370 ;
Capacity_Ah = 250;
battEnergyDensity = 240; % Wh/kg 

%% Trip 
slope = 1; %radian

%% Equations
Capacity_kWh = Capacity_Ah*NominalVoltage/1000*(battery_high_cut_off-battery_low_cut_off)/100 %%* 0.8 because the available capacity is from 10%-90% due to sfety limits;
massBatt = Capacity_kWh * 1000 / battEnergyDensity; % kg

inertia_tire = 0.5 * massTire * radiusTire^2;
massSPC = massBatt + massCaravan + massStorage + nTires * massTire; %kg

inertialMassSPC = (massSPC + nTires * inertia_tire / radiusTire^2) * towing_ratio;