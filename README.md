# klipper_probing_test
Test installation of homing/probing fixes for multi-mcu probing in Klipper

## What is this?
Currently in Klipper if running multiple MCUs you may run into the issue described here:

[Multiple Micro-controller Homing and Probing](https://www.klipper3d.org/Multi_MCU_Homing.html)  

When you have a probe or endstops on a seperate MCU than the MCU(s) controlling the steppers, the homing/probing can "overshoot".  
Since the communication between MCUs is not instant the steppers may keep moving additional steps before the MCU recieves the endstop/probe trigger.  

This is compounded if you have multiple MCUs controlling different steppers, each may recieve the signal at a seperate time.  
Which is why this is currently not allowed in Klipper.  

Currently Klipper keeps communications synchronized with a worst case latency of 25ms.  
But as the table shows below, depending on your homing speed, your steppers may be lower than expected by muliptle layer heights.  
Or worse... If you removed the multiple stepper MCU check in Klipper now your steppers may be misaligned.

![image](https://github.com/TheFuzzyGiggler/klipper_probing_test/assets/17093387/b2ee7323-c524-45da-af4d-305372d69fa0)  

## So how do we fix it?

This is where you, my intrepid 3d printing comrade, come into the story.

You see, when Klipper does homing/probing moves it keeps a strict eye on the exact time of each event, both the stepper motor steps and the triggers.  
It does this so well in fact, you can tell where the stepper motors WERE when the probe/endstop was triggered, and where they ended UP when they "halted".  

My patch simply takes the difference between the halting position and the trigger position and moves the stepper motors back to the position they were at when the probe/endstop triggered.  
Thus restoring balance to all things and bringing accuracy and good tidings to all of Klipperdom.

How do you play into this? Well, my above theory on my patch is good in.. er.. theory... and it's worked well for me... It needs wider testing before prime-time.

So this is my call for aide from the Klipper community.  
Come forth adventurers and try thy hand at increased homing/probing accuracy.  
(Don't worry, It's reversable)


## Installation
```
cd ~
git clone https://github.com/TheFuzzyGiggler/klipper_probing_test.git
cd klipper_probing_test
./install.sh
```
If you get a permission denied error, simply run
```
chmod +x install.sh
./install.sh
```
## Uninstall
To remove the probing patch and revert back to the original file
```
cd ~
cd klipper_probing_test
./install.sh uninstall
```




