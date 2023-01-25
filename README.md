# SPC-Model

This repository contains a simulink model of a self-propelled-caravan (SPC), an electric caravan designed to extend the range of an EV towing the caravan.


### Authors
This model has been made by group SPC-3: Tjeerd Bakker, Alexandru Savca and Jonathan Schaaij.

## How to run the model

- Open Matlab
  - the version we used is version R2023a
  - The following Add-Ons are used:
    - Simulink
    - 
    - Simscape
    - Simscape-Electrical
    - Simscape-Battery
    - Simscape-Driveline
    - Vehicle Dynamics Blockset
- Run `run_model.m`
  - This initializes all variables and constants required to run the simulation a more detailed explanation can be found below.
- Open SPC_model.slx
  - This is the main Simulink-file, which combined all other models.

## Variables

|Variable|Description|
|--------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|aeroDragCoeff|This constant determines the drag on on the Caravan, A typical caravan has a drag coeffient of 0.45, which is between that of a car and a small bus [Source](https://doi.org/10.1017/S0001924000064642). However, the drag on the caravan is lower, when a car is pulling it.|
|rollingResistCoeff| |
|frontArea| The frontal area of the caravan assuming a width and height of 2m|
|regen_efficency| How much energy can be stored during regenerative breaking. This value accounts for inefficencies outisde of the internal resistances of the battery and motor|
|motor_gear_ratio|The motor is connected to the wheels via a fixed gear, this gear ratio can be adjusted here.|  
|towing_ratio = 1|This variable determines the effective power the caravan needs to supply, a value of 1 assumes zero interaction forces between the car and the caravan (with the exception of turning forces, which are not included in this model), and a value of zero means that the car does all the work. The center of mass(CM) also influences this value, since if the CM is close to the car, the car has to carry more load of the caravan.|
|massCaravan|The mass of the empty caravan, including the framing and the motor, but not including the batteries|
|massStorage|The mass of the items people bring with them, such as tent, clothes, pans etc.|
|nTires| The amount of tires the caravan has. By default we assume one driven axle, therefore, 2 tires in total.|
|massTire| The mass of a single tire. By default 20 kg [Source](https://www.tuningblog.eu/kategorien/tipps_tuev-dekra-u-co/leichte-reifen-345639/)|
|radiusTire| default diameter is 17 inches, which converts to 216mm radius [Source](https://www.tuningblog.eu/kategorien/tipps_tuev-dekra-u-co/leichte-reifen-345639/)|
|rated_speed| Rated maximum speed of the motor. By default 25000 rpm|
|rated_load| Rated power of the motor, by default 350kW|
|battery_cut_off| Minimum state of chare(SOC) before the battery cuts off, this limitation is set to prolong the battery lifetime|
|NominalVoltage| NominalVoltage of the battery. By default we chose 370, which is the result of 100 lithium-ion cells in series|
|Capacity_Ah|The battery capacity in Ah. By default 300|
|battEnergyDensity|Energy density of the battery cells. Default is 240 Wh per kg, based on calculations from [this](https://www.uetechnologies.com/how-much-does-a-tesla-battery-weigh) source|
|slope|Average slope during the whole trip in degrees, to make it a slope-profile instead of a constant value, the simulink block needs to be change|

Other variables and constants, suhc as the mass of the battery, the intertia of the tires and the total mass are calculated from the above described variables.
## Simulink model explaination

The main model flow start at the drive-cycle. We use two different drive cycles the first drive cycle is the standart FTP75 drive cycle which is accurately describes inner city driving, or driving around a town. The second drive cycle is artemis, which is a measurement done on a highway. For longer simulations we took the highway measurements and copied it to create a larger dataset useful to simulate an entire battery discharge.
The drive cycle specifies the velocity at a certain time. We feed this velocity into a `Longitudinal Driver` block

## Future Work

- Include a model of the pulling car
    - maybe a presets of popular EVs, such as a tesla model 3 or an Audi E-tron
- Simulate the airodynamics of pulling a caravan
    - is is quite important since air drag is the most imporant aspect towards efficiency. 
- 3D-model with turning forces
- SlopeCycle - including multiple altitudes along a route
- 
