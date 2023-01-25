% Author: Tjeerd Bakker, Jonathan Schaaij, Alexandru Savca 
clear;
close all;
clc;

%% Constant
airDensity = 1.293;% kg/m^3
gravity = 9.81; %m/s^2

%% Design tunable
aeroDragCoeff = 0.3;
rollingResistCoeff = 0.012;
frontArea = 4; %m^2

regen_efficency = 0.7; % 
motor_gear_ratio = 8; %    
towing_ratio = 1; % how much does the caravan pull itself

massCaravan = 300; % kg 
massStorage = 300; % kg

nTires = 2;
massTire = 20; %kg
radiusTire = 0.215; %m    

%% Motor params
rated_speed = 25000; %rpm
rated_load = 350; %kW

%% Battery param
battery_cut_off = 10; % at XX% battery charge the simulation will stop
NominalVoltage = 370 ;
Capacity_Ah = 300 ;
battEnergyDensity = 240; % Wh/kg 

%% Trip 
slope = 0; %radian

%% Equations
Capacity_kWh = Capacity_Ah*NominalVoltage/1000 ;
massBatt = Capacity_kWh * 1000 / battEnergyDensity; % kg

inertia_tire = 0.5 * massTire * radiusTire^2;
massSPC = massBatt + massCaravan + massStorage + nTires * massTire; %kg

inertialMassSPC = massSPC + nTires * inertia_tire / radiusTire^2 * towing_ratio;