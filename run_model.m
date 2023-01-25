% Author: Tjeerd Bakker, Jonathan Schaaij, Alexandru Savca 
clear;
close all;
clc;

%% Constant
airDensity = 1.293;% kg/m^3
gravity = 9.81; %m/s^2

%% Design tunable
aeroDragCoeff = 0.2;
rollingResistCoeff = 0.01; % TODO: determine source
frontArea = 4; %m^2

regen_efficency = 0.7; % 
motor_gear_ratio = 8; %    
towing_ratio = 1; 
% How much of should the caravan push itself 
% 1: Almost no interaction forces
% 0.5 : the load of the caravan is evenly separated between the vehicles 
% 0: The carvan is being pulled completely

massCaravan = 300; % kg 
massStorage = 300; % kg

nTires = 2;
massTire = 7; %kg
radiusTire = 0.3; %m    

%% Trip 
slope = 0; %radian

%% Motor params
rated_speed = 25000; %rpm
rated_load = 350; %kW

%% Battery param
battery_cut_off = 10; % at XX% the simulation will stop, battery will not deliver more power
NominalVoltage = 370 ;
Capacity_Ah = 300 ;
Capacity_kWh = Capacity_Ah*NominalVoltage/1000 ;
battEnergyDensity = 240; % Wh/kg 
massBatt = Capacity_kWh * 1000 / battEnergyDensity; % kg


%% Equations

inertia_tire = 0.5 * massTire * radiusTire^2;
massSPC = massBatt + massCaravan + massStorage + nTires * massTire; %kg

inertialMassSPC = massSPC + nTires * inertia_tire / radiusTire^2 * towing_ratio;

% TODO: center of mass on axis of car, behind, in front. Changes the
% rolling resistance. 