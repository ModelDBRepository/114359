=========README FOR THE MULTIPLE RUN CONTROL==============
PURPOSE OF THE MULTIPLE RUN CONTROL:

Simplifying parameter scans in NEURON (www.neuron.yale.edu)
and subsequent analysis in e.g. MATLAB.

============================================================
CREDITS:

AUTHOR: Ronald van Elburg  (RonaldAJ at vanElburg eu)

This code was first published on http://senselab.med.yale.edu/modeldb/,
accession number 114359 accompanying the paper: 
	 R.A.J. van Elburg and Arjen van Ooyen (2010) `Impact of dendritic size and
     dendritic topology on burst firing in pyramidal cells', 
     PLoS Comput Biol 6(5): e1000781. doi:10.1371/journal.pcbi.1000781.
Please cite both the paper and the ModelDB entry when you use
this software to prepare a publication.

This software is released under the GNU GPL version 3: 
http://www.gnu.org/copyleft/gpl.html

OTHER CONTRIBUTIONS:
The file nrn_vread.m for reading neuron binaries into matlab was first 
published by Konstantin Miller on the Neuron forum.
============================================================

Usage of the multiple run control (MRC):

For the example in the discussion below we will assume that you have loaded
MRC_DemoNetwork.hoc which contains a toy model for demonstrating the MRC. 

For the first use in a project start with loading MultipleRunControl.hoc using
the file menu. Then create an objref and create an instance of the
MultipleRunControlGUI:
	// Code Start
		objref myMRC
		myMRC=new MultipleRunControlGUI()
	// Code End
A window named MultipleRunControlGUI[0] should now appear. 

Before discussing the main functionality available in the lower two colums, we
will first discuss the buttons at the top. The `Set Protocol' button allows you
to pick the output format, at present matlab m-file and the neuron binary 
formats are supported. For quick and small work and testing matlab m-file can be
usefull as they are intuitive to use and you can inspect the result
(unfortunately all m-files read are kept in matlab memory, making this a very
resource wasting solution), for larger projects or if you want to use your data
in another environment the neuron binary format is recommended. Connected to
this is the check box at the right, in general indices will start at 0 this
however is impractical in applications in which indexing starts at 1 there for
the option is provided to start indices at 1. The button `Single Run' will start
a single run, and will execute the following functions which we will discuss
shortly: MRC_PrepareModel() preparerun() MRC_Run() printtofile().  The button
`Loop Run' will start a sequence of runs scanning over the  parameters specified
in the lower left column. After every  parameter change it executes the same
steps as executed after pushing the single run button: MRC_PrepareModel()
preparerun() MRC_Run() printtofile() without changing. 

The functions MRC_PrepareModel() and  MRC_Run() are available for the user to be
overwritten.  Use MRC_PrepareModel() to make structural changes to a
model, like adding or removing model components (e.g. sections or point
processes). Using MRC_PrepareModel() ensures that the function preparerun()
will link the output handlers to the correct instances of the model
components. The function preparerun() will further initialize these output
handlers. Use MRC_Run to make a change to a set of model parameters based on a
single loop parameter (e.g. the synaptic time constants of all inhibitory
synapses in a network). Make sure that you always include a call to NEURON
default run in MRC_Run:
	// Code Start
	proc MRC_Run(){
		// Here goes your code for changing parameter settings
		run()
	}
	// Code End
The function  printtofile() will call the output handlers and make them write
the recorded variables to file.  In the case of a single run these output files
will be <Basename>.m for Matlab output or <Basename_OutparamReferenceName>.dat
for neuron binary output. Similarly using the `Loop Run' button to produce a
parameter scan you will  obtain output files like
<Basename>_<LoopPar1>_<LoopPar2>.m for Matlab files and
<Basename>_<LoopPar1>_<LoopPar2>_<OutparamReferenceName>.dat for neuron binary
output.  The Basename is set using a dialog which appears after pushing the 
"Set Basename for Output Files", depending on the operating system forward
slashes and backward slashes can be used to indicate subdirectories.
Furthermore, a directory for saving simulation results needs to be created
before writing to it.

Adding loop parameters:
The "Loop Params" button can be used to switch the mode for editing the list of
parameters which will be scanned by the MRC and for adding new loop params to
the loop parameter list.  To add a new loop parameter, first select the option
"add" after pushing the "Loop Params" button, then pick the variable you want
to vary (which therefore needs to exist at this point), e.g.
NetStimList.o(0).noise. You can now proceed adding more loop variables or you
can move on to setting the scan range by pressing the "Loop Params" button and
selecting "Edit". Above the list the "..." should change to "Edit". Now by
double clicking a dialog box appears in which you can edit scan range and
stepsize (for now it is best to ignore the last three numbers and set or keep
them at 0), e.g. `0 0.9 0.3 0 0 0' would make the variable start a run at a
value of 0 then 0.3 then 0.6 and finish with a run for 0.9, if the end of the
range is not reached in an integer number of steps the last run will be executed
with the last step still within the range (load session MRC_DemoMRC_1.ses). It
is important to realize that the indices of the files will be integers,
calculated as follows (parametervalue-lower limit)/stepsize to which 1 will be
added if the "Start indices  at 1 (default=0)" is checked. The "Remove" mode
will turn doubleclicking a loop parameters in to removal of that parameter, the
"Toggle" mode allows you to disable and enable a parameter (+ enabled,
-disabled) and the "Up" and "Down" modes will change the order of the loop
parameters. The order of the loop parameters determines the nesting of the loops
and the position of the
index in the name of the output file. The top enabled loop parameter is for the
outer loop and the corresponding index appears first in the output file name. If
you want to make a coordinated change to several parameters at the same time, it
is best to define a single variable, which is then used in MRC_Run to set all
these parameters. If for example we want to vary the interspike interval of the
stimulus in our demo network, we could define a NOISEINTERVAL variable for
looping and change MRC_Run to:
	// Code Start
	// Provide default NOISEINTERVAL value to make `Single Run' functional
	NOISEINTERVAL=10
	proc MRC_Run(){
		NetStimList.o(0).interval=NOISEINTERVAL
		NetStimList.o(1).interval=NOISEINTERVAL
		// And make sure to call the standard run after these 
		// parameter changes:
		run()
	} 
	// Code End
Now if we press `Loop Run' the loop parameter NOISEINTERVAL will be used to set
the interval of both NetStim objects (Result directly accessable via load
session MRC_DemoMRC_2.ses).

Adding output parameters:
The "Out Params" button can be used to switch the mode for editing the list of
output parameters which will be written by the MRC to file and for adding new
output parameters to the output parameter list. To add a new output parameter,
first select the option "Add" after pushing the "Out Params" button, which gives
you a dialog in which you can enter the name used in the output  filename (for
binary files) or in the variable name (for matlab .m files).

Then use  "Out Params" button again and pick the "Type" mode. With the type mode
you can determine the type of variable you want to write to file (which
therefore needs to exist at this point), possible type are "Time Series" which
will output two vectors one with the values of the parameter at every timestep
and a second with vector containing the times at which the value were determined
(thus allowing recording of time series with variable timestep methods);
"Spiketrain" for recording spike times and "Scalar" for calling scalar functions
 or exporting variable values at the end of a simulation.

Now selecting "Edit" mode we can define the actual output parameter. This is
slightly different for the different types which we will therefore discuss
separately below.

*Time Series

Use "Pick name  ..." to pick the variable you want to write to file at
tstop. The shortname specified is used in the output: either to specify the
variable name in the m-file or as part of the filename for neuronbinary files.
If for example we want to save a membrane potential trace of the second HHCell
from our demo network we can add a VmHH2 variable choosing `Add' from the `Out
Params' menu, then we can pick its type using `Output Type' from the `Out
Params' menu and double clicking on the newly created entry. Now we check `Time
Series' and click `Accept'. Now we pick `Edit Output Var' from the `Out Params'
menu, double click on the `VmHH2' entry and use the buttons
`Sectionname/Artificial Cellname' and `Membername' to define the variable for
wehich we want a trace. We can preset these using the `Pick name ...' button,
which allows us to search for the variable in the same way as the `Plot What?'
functionality works in the standard NEURON graphs. Using this button we can
preset both the Sectionname and Membername to "HHCell_Cell[1].soma.v(0.5)",
which we can then edit to "HHCell_Cell[1].soma" for the sectionname and "v(0.5)"
for the membername. This works, but in this case better programming style would
be to use the HHCellList and replace "HHCell_Cell[1].soma" with
"HHCellList.o(1).soma". (Result directly accessible via load session
MRC_DemoMRC_3.ses). We can now have a first look at the output. Press `Set
Protocol' and check `Make printtofile() generate matlab output' and press
`Single Run', now you can inspect the result with a simple texteditor, you will
see a two column matlab object:
// Start matlab output below this line
%Matlab object for: VmHH2
VmHH2 =[
0	-65
...
500	-64.9737
];
// End matlab output above this line
In this object the first column contains the simulation timesteps and the second
the membrane potential at those timesteps. 


*Scalar functions

Use "Pick name" to pick the variable you want to save. The shortname specified
is used in the output: either to specify the variable name in the m-file or as
part of the filename for neuronbinary files. Alternatively instead of a variable
name it is also possible to call a function here. As this is untill now the most
common way we used scalar output in our projects, it turns out that in general
scalars that are not a function of model changes are parameters in the model
specification, and therefore known before hand. So lets us assume we want to
know the input conductance of our first HHCell, input conductance can be
determined using the ImpedanceTool, which we wrap in a function getic():
// Start code below this line
objref ImpedanceTool
func getic(){local ic
    HHCellList.o(0).soma {
        ImpedanceTool=new Impedance()
        ImpedanceTool.loc(0.5)
        ImpedanceTool.compute(0)
        ic=1/ImpedanceTool.input(0.5)    // Input conductance in micro Siemens
    }

    objref ImpedanceTool
    return ic
}
// End code above this line
Now we can go through the moves of adding a scalar output handler to the MRC. 
We first add a the inputconductance variable to the output parameters choosing
`Add' from the `Out Params' menu, then we can pick its type using `Output Type'
from the `Out Params' menu and double clicking on the newly created entry. Now
we check `Scalar' and click `Accept'. Now we pick `Edit Output Var' from the
`Out Params' menu, and double click on the `inputconductance' entry. In the
dialog popping up we press the `Pick name' button and type getic(). (Result
directly accessible via load session MRC_DemoMRC_4.ses). If we prefer we can
still change the shortname used in the output by clicking the corresponding
button and changing the shortname to for example "ic". If we now press `single
Run' the generated matlab file will have in its last lines: %Matlab object for:
inputconductance ic = 0.00546261;
// Start matlab output below this line
%Matlab object for: inputconductance
ic = 0.00546261;
// End matlab output above this line

*** Its is time for warning here:
***	When rerunning the MRC the results are added to the already existing files,
***	so you have to make sure your previous results, test runs etc. are deleted 
***	before you start a new scan.
***
*** 	If you tried all the examples above this should be visible in the matlab files 
***     generated.

*Spike trains
We postponed treatment of the spike train handler to this point, because some
familiarity with the two other handlers helps in dealing with this more complex
handler. The complexity is the result from the desire to be able to deal with
spikes generated by both artificial and conductance based cell models and to be
able to deal with a collection of cells or sections. 

				
Using the different types in the spiketrain handler:
		
		For a list of compartmental models specify separately the name of the
		list/vector of cells over which you want to measure in
		`Variable(s) name part I', the section from which you want to 
		measure  `Variable(s) name part II' and the parameter in `Membername'.
		
		Sectionlist, Section (Set): Specify the section set or sectionlist with 
		`Variable(s) name part I' and leave `Variable(s) name part II' open. Now 
		you can specify the outparameter from this section in the membername part.
		
		Artificial cells: Specify the list/vector of artificial cells  with 
		`Variable(s) name part I' and check `Listobjects are artificial cells' 
		
		Single Artificial cell: Specify the name of the artificial cell  with 
		`Variable(s) name part I' 	

Setting spike thresholds:
		For the spike train handler to function properly it needs to
		have a threshold set, by default it is set to 0 but the handler
		can be used to set it to an arbitrary value. A word of caution
		is needed here however: in neuron the last threshold set
		for a variable determines the thershold used by all NetCon
		objects connencted to it. If therefore you want to specify a
		threshold for each cell which is not touched by the MRC you have
		to specify it after preparerun() has been called, i.e. you have
		to overwrite MRC_Run and provide specification of the thresholds
		there. 


We illustrate this handler based on demo code, to see what you need to fill out run:
		nrngui MRC_DemoNetwork.hoc MRC_DemoMRC_*.ses
where the star can be read of from the list below:
		Networks of spiking cells:
				List of conductance based cell models (MRC_DemoMRC_5a.ses):
						HHCellList
				List of artificial Cell Models (MRC_DemoMRC_5b.ses):		
						NetStimList
						ArtCellList
				SectionList (MRC_DemoMRC_5e.ses):
						SomaticSections
				Single Artificial Cell	(MRC_DemoMRC_5f.ses):	
						ArtCellList.o(0)
						IntFire4_IntFire4[0]
		Single cell:				
				Section (MRC_DemoMRC_5c.ses):
						cellbody
						dend1[0], dend1[1], dend1[2]
						dend2[0], dend2[1], dend2[2]
				Section Set (MRC_DemoMRC_5d.ses):
						cellbody	contains: cellbody
						dend        contains: dend1[0],dend1[1],dend1[2],dend2[0],dend2[1],dend2[2]
						dend1		contains: dend1[0],dend1[1],dend1[2]

* Reading your simulation data into matlab
The function nrn_vread (written by Konstantin Miller) can be used to read the
binary data into matlab. The file MRC_LoadSimData.m shows how you can use this
to read in the data generated using the MRC_DemoMRC_5c.ses sessionfile.

* Restarting your parameter scan at a specified point
This is typically done from the GUI and not from a session file. If you perform
a long scan you might run into a cleaning personel switching off your computer, a power
surge or some other problem that stops your computer. You can recover from these
problems by using the restart possibilities of the MRC. Just reload your MRC
using load session. And edit the loop paramaters. By changing for example the
string for NOISEINTERVAL (from MRC_DemoMRC_4.ses) from `10 50 10 0 0 0' to `10
50 10 1 30 0' you can force a restart. When a parameter in a loop which is
surrounding the loop for which the restart is set is incremented then the scan
will use the full range again.

Unfortunately the restart feature is at present only functional for loop
parameters which have only alphanumerical symbols in them. So
e.g. NetStimList.o(0).noise can not be used for restart. However you can always set  
NetStimList.o(0).noise=NetStimList_o0_noise in MRC_Run and use
NetStimList_o0_noise as a loop parameter to circumvent this problem.

* Poormans paralellization: dividing the parameter range in slices or blocks

For paralellization the session file needs to be edited and then copied several
times and then run. So we are going to prepare a session file 
MRC_DemoMRC_Parallel.ses which we can use to split our parameter scan over 
several processors. And which we can start from a shell script in the following 
fashion:
// Start bash script below thbis line
#/bin/bash
NRNHOME=/usr/local/bin
BINDIR=/bin

# Run slices
$BINDIR/cp MRC_DemoMRC_Parallel.ses MRC_DemoMRC_Parallel_0.ses
$NRNHOME/nrngui -c MRC_Slice=0 MRC_DemoMRC_Parallel_0.ses &

$BINDIR/cp MRC_DemoMRC_Parallel.ses MRC_DemoMRC_Parallel_1.ses
$NRNHOME/nrngui -c MRC_Slice=1 MRC_DemoMRC_Parallel_1.ses &

# etc. 
// End bash script above this line

For parallelization auxilary variables have been added to the MRC code. 
Setting the MRC_Slice variable before loading the MRC will make the MRC aware
that slicing is used, the value of MRC_Slice will then be copied to MRC_SliceNo
which is accesible in the loop parameter blocks in the session files. NEURON 
provides the possibility to pass a parameter value at startup with the `-c'
switch, which we use here to specify the slice or block number (e.g. `-c MRC_Slice=1'). In the loop parameter blocks we can furthermore access  the 
MRC_SliceIndex, MRC_StepsInSlice, MRC_NoOfSlices variables, which can contain an array of doubles. For convenience we also provide the MRC_GetIndex function, which calculates the index for the current loop parameter based on the MRC_NoOfSlices array. In our first example session file code we will directly use the MRC_SliceNo, in the second example we will use the auxilary arrays and MRC_GetIndex to work with a block structure.

Suppose we have a scan over a parameter X which takes on all integer values
starting from 1000 upto and including 2000. Suppose we want to split this scan
in 4 approximately equal parts. Then we set the restart variable for the loop
parameter to 2, and we define restart_at and end_before values which depend
on MRC_SliceNo. Now all parameter points which fall into the half open
interval [restart_at,end_before) will be scanned when invoking this script.
// Start session file snippet
{protocol=tobj}
{tobj=new MRC_LoopParameter()}
	{object_push(tobj)}
	{
		name="X"
		lower_limit=1000
		upper_limit=1999
		stepsize=1
		// Start added code  slicing
		restart=2  	 // restart=2 indicates that we are using slicing as opposed to ordinary restarting for which restart=1
        restart_at=lower_limit+ MRC_SliceNo*(upper_limit-lower_limit+stepsize)/4
        end_before=lower_limit+ (MRC_SliceNo+1)*(upper_limit-lower_limit+stepsize)/4
		// End added code  slicing
		use=1
		setdisplaytext()
	}
	{object_pop()}

{looppars.append(tobj)}
// End session file snippet

Now sometimes in the case of multidimensional scans it might be desirable to
further break down the scan into blocks, this is possible with essentially the
same technique, except that for convenience an extra parameter and some 
predefined functions can be used. Suppose that next to our
original X we also scan a parameter Y from 7 to 10 in steps of size 0.75 a loop
nested in the X loop. (This example can be run with nrngui -c MRC_Slice=0 
MRC_DemoMRC_Parallel.ses, varying the value of MRC_Slice will show how the 
blocks are expressed in the MRC. )
// Start manually added code for defining a block
// Be aware that the upper_limit, lower_limit and stepsize variables are not
// available outside an MRC_LoopParameter and that MRCSlice is not available
// inside an MRC_LoopParameter. Only MRC_SliceNo, MRC_SliceIndex,MRC_StepsInSlice
// are available and shared between all loop parameters and the outside world
//
// Allocate MRC_SliceIndex and MRC_StepsInSlice
double MRC_SliceIndex[2]
double MRC_StepsInSlice[2]
double MRC_NoOfSlices[2]
MRC_NoOfSlices[0]=4
MRC_NoOfSlices[1]=5
// End manually added code for defining a block


{tobj=new MRC_LoopParameter()}
	{object_push(tobj)}
	{
		name="X"
		lower_limit=1000
		upper_limit=1999
		stepsize=1
		use=1
		
		// Start manually added code for defining a block
		MRC_StepsInSlice[0]=(upper_limit-lower_limit+stepsize)/(MRC_NoOfSlices[0]*stepsize) // This number should be an integer
		MRC_SliceIndex[0]=MRC_GetIndex(2,MRC_SliceNo,2)//int(MRC_SliceNo/MRC_NoOfSlices[1])
		restart=2  	 // restart=2 indicates that we are using slicing 
        restart_at=lower_limit+ MRC_SliceIndex[0]*MRC_StepsInSlice[0]*stepsize
        end_before=lower_limit+ (MRC_SliceIndex[0]+1)*MRC_StepsInSlice[0]*stepsize
		// End manually added code for defining a block	 
		
		setdisplaytext()
	}
	{object_pop()}

{looppars.append(tobj)}
{tobj=new MRC_LoopParameter()}
	{object_push(tobj)}
	{
		name="Y"
		lower_limit=7
		upper_limit=10
		stepsize=0.75
		use=1
		
		// Start manually added code for defining a block
		MRC_StepsInSlice[1]=(upper_limit-lower_limit+stepsize)/(MRC_NoOfSlices[1]*stepsize) // This number should be an integer
		MRC_SliceIndex[1]=MRC_GetIndex(2,MRC_SliceNo,2)//int(MRC_SliceNo-MRC_NoOfSlices[1]*MRC_SliceIndex[0])
		restart=2  	 // restart=2 indicates that we are using slicing 
        restart_at=lower_limit+ MRC_SliceIndex[1]*MRC_StepsInSlice[1]*stepsize
        end_before=lower_limit+ (MRC_SliceIndex[1]+1)*MRC_StepsInSlice[1]*stepsize
		// End manually added code for defining a block
		setdisplaytext()
	}
	{object_pop()}

{looppars.append(tobj)}
// ...

// For automatic execution when calling from a shell script add:
if(name_declared("MRC_Slice")==5){
 execute("looprun()",MultipleRunControlGUI[0])
}

// End session file snippet


* Session files
You might discover that it is easier to work with the MRC from a session file.
Using the standard NEURON tools you can save the MRC to a session file. To reuse
it you might have to edit the point in the session file where the
MultipleRunControlGUI is loaded from file, cause if the MRC code is not in the
same directory NEURON will not be able to find it. So in the code as shown below
just change the string "MultipleRunControl.hoc" so that it includes the
(relative) path to the MRC:
		// Start code snippet MRC session file
		//Begin MultipleRunControlGUI[0]
		{
		load_file("MultipleRunControl.hoc","MultipleRunControlGUI")
		}
		// End code snippet MRC session file
