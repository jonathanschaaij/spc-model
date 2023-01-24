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

massBatt = 600; % kg
massCaravan = 100; % kg
massStorage = 100; % kg

nTires = 2;
massTire = 7; %kg
radiusTire = 0.3; %m    

%% Trip 
slope = 0; %radian
%% Battery param
NominalVoltage = 370 ;
Capacity_Ah = 300 ;
Capacity_kWh = Capacity_Ah*NominalVoltage/1000 ;

%% Equations

inertia_tire = 0.5 * massTire * radiusTire^2;
massSPC = massBatt + massCaravan + massStorage + nTires * massTire; %kg


inertialMassSPC = massSPC + nTires * inertia_tire / radiusTire^2;


% TODO: center of mass on axis of car, behind, in front. Changes the
% rolling resistance. 