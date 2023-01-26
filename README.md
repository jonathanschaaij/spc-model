# SPC-Model

This repository contains a simulink model of a self-propelled-caravan (SPC), an electric caravan designed to extend the range of an EV towing the caravan.

## Authors

This model has been made by group SPC-3:

- Tjeerd Bakker s2097966
- Alexandru Savca s2262525
- Jonathan Schaaij s2374862

## How to run the model

- Open Matlab
  - the version we used is version R2023a
  - The following Add-Ons are used:
    - Simulink
    - Simscape
    - Simscape-Electrical
    - Simscape-Battery
    - Simscape-Driveline
    - Vehicle Dynamics Blockset
- Run `run_model.m`
  - This initializes all variables and constants required to run the simulation a more detailed explanation can be found below.
- Open `SPC_model.slx`
  - This is the main Simulink-file, which combined all other models.
  - If you get an error ... 

## Input Variables

|Variable           |Description|
|-------------------|-----------|
|aeroDragCoeff      |This constant determines the drag on on the Caravan, A typical caravan has a drag coeffient of 0.45, which is between that of a car and a small bus [Source](https://doi.org/10.1017/S0001924000064642). However, the drag on the caravan is lower, when a car is pulling it.|
|rollingResistCoeff |The rolling resistance coefficient is affected by the load distribution and the number of wheels|
|frontArea          |The frontal area of the caravan assuming a width 1.5m and height of 2m|
|regen_efficency    |How much energy can be restored during regenerative breaking. This value accounts for inefficencies outisde of the internal resistances of the battery and motor|
|motor_gear_ratio   |The motor is connected to the wheels via a fixed gear, this gear ratio can be adjusted here.|  
|towing_ratio = 1   |This variable determines the effective power the caravan needs to supply, a value of 1 assumes zero interaction forces between the car and the caravan (with the exception of turning forces, which are not included in this model), and a value of zero means that the car does all the work. The center of mass(CM) also influences this value, since if the CM is close to the car, the car has to carry more load of the caravan.|
|massCaravan        |The mass of the empty caravan, including the framing and the motor, but not including the batteries.|
|massStorage        |The mass of the items people bring with them, such as tent, clothes, pans etc.|
|nTires             |The amount of tires the caravan has. By default we assume one driven axle, therefore, 2 tires in total.|
|massTire           | The mass of a single tire. By default 20 kg [Source](https://www.tuningblog.eu/kategorien/tipps_tuev-dekra-u-co/leichte-reifen-345639/)|
|radiusTire         | default diameter is 17 inches, which converts to 216mm radius [Source](https://www.tuningblog.eu/kategorien/tipps_tuev-dekra-u-co/leichte-reifen-345639/)|
|rated_speed        | Rated maximum speed of the motor. By default 25000 rpm|
|rated_load         | Rated power of the motor, by default 250kW|
|battery_low_cut_off    |Minimum state of chare(SOC) before the battery is disconnected, this limitation is set to prolong the battery lifetime|
|battery_high_cut_off   |Maximum state of chare(SOC) before the battery is disconnected from charging, this limitation is set to prolong the battery lifetime due to temperature effects|
|NominalVoltage     | NominalVoltage of the battery. By default we chose 370, which is the result of 100 lithium-ion cells in series|
|Capacity_Ah        |The battery capacity in Ah. By default 300|
|battEnergyDensity|Energy density of the battery cells. Default is 240 Wh per kg, based on calculations from [this](https://www.uetechnologies.com/how-much-does-a-tesla-battery-weigh) source|
|slope              |Average slope during the whole trip in degrees, to make it a slope-profile instead of a constant value, the simulink block needs to be changed|

Other variables and constants, such as the mass of the battery, the intertia of the tires and the total mass are calculated from the above described variables.


## Simulink model explaination

The main model flow start at the drive-cycle. We use two different drive cycles the first drive cycle is the standart FTP75 drive cycle which is accurately describes inner city driving, or driving around a town. The second drive cycle is artemis, which is a measurement done on a highway. For longer simulations we took the highway measurements and copied it to create a larger dataset useful to simulate an entire battery discharge.

The drive cycle specifies the velocity at a certain time. We feed this velocity into a `Longitudinal Driver` block. This is basically a pre-tunes PID system optimized for a driving cylce and outputs a value between 0 and 1, for both the acceleration and deceleration.
These values go into the `motor_PWMController`. There the acceleration value drives a PWM-signal which drives the H-bridge connected to a DC-Motor. The deceleration signal toggles the breaking functionality on the H-bridge, which enable regenerative breaking on the motors. We have not implemented an other breaking system, since this could be handled by the car pulling the caravan. Additionally, regenerative breaking if sufficient most of the time.
The DC-motor is connected to a theoretically perfect gear, which is connected to a rotational to linear converter, which has a power output in the forwards direction.

The motor power flows into the `mechanicalbody_model` which simulated the mass of the caravan with it's position and velocity. The caravan is modelled as an intertial point mass, this mass included the actual total mass of the body, but it also includes the rotational interia of the wheels. This is important since the energy pulling on the caravan is partially being converted to rotational momentum and not just translational momentum, which determines the velocity.
The `mechanicalbody_model` also includes all other forces acting on the caravan such as the rolling resistance, an optional gravitational force resulting from a slope and finally a simplified version of the drag force. The drag force is modelled as a simple force acting only on the caravan, but in the real world the drag is acting on the combined system of the caravan and the pulling car. To properly model this, computational fluid dynamic(CFD) simulations need to be done, to determine the total drag force on the car and on the caravan seperately, which is beyond the scope of this assignment. By using Simscape to link the movement of the caravan to the motor we automatically receive bi-directional power flow, which is important for features such as regenerative breaking.

The `motor_PWMController` also outputs the motor current, which is directly correlated to the current going through the battery which is simulated in `battery_model` using the built-in `BatteryPack` block. We chose to use this block instead of making a manual model, since this method is more accurate and less time consuming. This models includes charging and the typical voltage curve for Lithium-Ion batteries.

To determine the remaining range and efficiency of the caravan is calculated in the `range_esstimation` model. There the driven distance is gathered from the mechanical model as well as the state of charge. From these values the used charge can be calculated to find the effiecency in km per kWh, which can then in turn be used to calculate the remaining range. So initially the efficiency is set to 1 km/kWh. When the simulation is started the efficiency is updated every hour(simulation time). 

## Output parameters

|Output parameters of the mdoel|
|Parameter          |Description|
|-------------------|-----------|
|Motor Current             |This shows the current in the motor which can either be positive(driving) or negative(regenerative braking)|
|Motor Voltage             |Shows the voltage needed to supply the motor|
|Battery Current           |The current drawn from the battery. The current in the motor is the same as the one in the battery. |
|Battery Voltage           |The voltage on the battery terminals|
|Battery SOC               |The state-of-charge of the battery |  
|SPC velocity              |The velocity of the caravan that tracks the velocity of the car |
|SPC efficiency            |The efficiency of the electric caravn in km/kWh |
|Remaining capacity        |The remaining capacity of the battery in kWh|
|Remaining driving range   |The remaining dricing range of the SPC|
|Traveled distance         |The driven distance|


## Influence of parameters

|The default values of the model input variables|
|Variable           |Value|
|-------------------|-----------|
|aeroDragCoeff      |0.18|
|rollingResistCoeff |0.008|
|frontArea          |3 m2|
|regen_efficency    |1|
|motor_gear_ratio   |7|  
|towing_ratio = 1   |1|
|massCaravan        |250 kg|
|massStorage        |200 kg|
|nTires             |2|
|massTire           |20 kg|
|radiusTire         |0.3 m|
|rated_speed        |25000 rpm|
|rated_load         |250 kWh|
|battery_low_cut_off    |5%|
|battery_high_cut_off   |95%|
|NominalVoltage     |370 V|
|Capacity_Ah        |350 Ah|
|battEnergyDensity  |240 Wh/kg|
|slope              |0 rad|

With the default parameters the SPC gives a 365 km range and an efficiency of 3.1 km/kWh. Both the range and the efficiency are influenced in the same way so only the offect of the variable on the range will be investigated



|The influence of parameters on range|
|Variable |Influence on range|
|---------|-------------------|
|aeroDragCoeff      |0.12|0.15|0.18||2.1|2.4|
|Range              |430 km|385 km|365 km|325 km|300 km|

|rollingResistCoeff |0.004|0.006|0.008|0.01|0.012|
|Range              |560 km|440 km|365 km|295 km|260 km|

|frontArea          |2 m2|2.5 m2|3 m2|3.5 m2|4 m2|
|Range              |430 km|388 km|365 km|327 km|302 km|

|regen_efficency    |0|0.25|0.5|0.75|1|
|Range              |127 km|165 km|200 km|266 km|365 km|
 
|towing_ratio = 1   |0.5|0.65|0.8|1|
|Range              |925 km|715 km|447 km|365 km|

|massSPC            |600 kg|700 kg|800 kg|900 kg|1000 kg|
|Range              |510 km||440 km|387 km|352 km|365 km|

|Capacity_Ah        |250 Ah|300 Ah|350 Ah|400 Ah|450 Ah|
|Range              |260 km|312 km|365 km|486 km|547 km|

|slope              |0|0.3|0.6|1|
|Range              |365 km|140 km|100 km|80 km|





## Future Work

- Include a model of the pulling car
  - maybe a presets of popular EVs, such as a tesla model 3 or an Audi E-tron
- Simulate the airodynamics of pulling a caravan
  - is is quite important since air drag is the most imporant aspect towards efficiency.
- 3D-model with turning forces
- SlopeCycle - including multiple altitudes along a route
  