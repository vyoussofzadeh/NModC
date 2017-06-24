# NModC

Using MATLAB, we designed a fairly simple graphical user interface (GUI) called “NModeC” for analysing the time evolution of proposed hybrid model where three interacting brain regions LHA, LC and DRN are modulated by orexin, norepinephrine and serotonin (5-HT) neurochemicals, respectively. The general idea is that a typical post synaptic neuron is indirectly influenced by a single presynaptic partner through one or more neurotransmitters that regulate diverse populations of neurons in the nervous system. The starting window of GUI “NModeC” after pressing ‘Start’ button exhibits changes of model outputs of three interacting brain areas over time. The outputs are the firing rate of three sources that are normalised in the range of [0, 1] and translated into color map in the range of [0, 255], where red represents the highest and blue represents the lowest firing rates, respectively. For easy interpretation, three regions are presented in a rough location based on their MNI coordinates overlaid on a glass brain. The 3D rotation of the brain is also allowed. The simple but fast Euler method with a time step equal to 1 milliseconds was employed to solve the state equations consist of 16 first order differential equation. Once the model is converged, the ‘Outputs’ button can provide the outputs for each area consist of concentration (release-and-reuptake/decay) dynamics and firing rate of each source with respect to time or firing rates from two other sources. The model parameters can be edited and by pressing ‘Simulate’ and ‘Outputs’ buttons, the corresponding results can be seen in both main window and the model outputs, respectively. Finally, the ‘Default’ button returns the default values of model parameters. 

To run "NModeC" please read below instrictions:

MATLAB Compiler

1. Prerequisites for Deployment 

Verify the MATLAB Runtime is installed and ensure you    
  have installed version 9.0.1 (R2016a).   

If the MATLAB Runtime is not installed, do the following:
  (1) enter
  
      >>mcrinstaller
      
      at MATLAB prompt. The MCRINSTALLER command displays the 
      location of the MATLAB Runtime installer.

  (2) run the MATLAB Runtime installer.

Or download the Windows 64-bit version of the MATLAB Runtime for R2016a 
from the MathWorks Web site by navigating to

   http://www.mathworks.com/products/compiler/mcr/index.html
   
   
For more information about the MATLAB Runtime and the MATLAB Runtime installer, see 
Package and Distribute in the MATLAB Compiler documentation  
in the MathWorks Documentation Center.    


NOTE: You will need administrator rights to run MCRInstaller. 


2. Files to Deploy and Package

Files to package for Standalone 

-NModC.exe
-MCRInstaller.exe 
   -if end users are unable to download the MATLAB Runtime using the above  
    link, include it when building your component by clicking 
    the "Runtime downloaded from web" link in the Deployment Tool
-This readme file 

3. Definitions

For information on deployment terminology, go to 
http://www.mathworks.com/help. Select MATLAB Compiler >   
Getting Started > About Application Deployment > 
Deployment Product Terms in the MathWorks Documentation 
Center.
