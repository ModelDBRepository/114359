Author: Ronald van Elburg  (RonaldAJ at vanElburg eu)

NEURON, Matlab and shell scripts for the paper:

R.A.J. van Elburg and Arjen van Ooyen (2010) `Impact of dendritic size and
dendritic topology on burst firing in pyramidal cells', 
PLoS Comput Biol 6(5): e1000781. doi:10.1371/journal.pcbi.1000781.

!!! Contains the MultipleRunControl a new native parameter scanning
!!! tool for NEURON.
!!! MultipleRunControl code and readme can be found in the /hoc/mrc
!!! directory.

This software is released under the GNU GPL version 3: 
http://www.gnu.org/copyleft/gpl.html

Purpose and Method:

This code was written to systematically investigate which of the
physical parameters controlled by dendritic morphology underlies the
differences in spiking behaviour observed in different realizations of
the 'ping-pong'-model introduced by Mainen and Sejnowski (1). Their
paper contains two variants of this dynamics one implemented on full
morphologies, on which we based the models found in the main model
file modelCellReConstruction.hoc and one reduced model on which we
based the models in modelSimplifiedCells.hoc but to which we added
topology as in earlier work by van Ooyen et al. (2,3). Structurally
varying dendritic topology and length in the simplified model allows
us to separate out the physical parameters derived from morphology
underlying burst firing. The presence of bursting is evaluated using a
measure introduced earlier by us (4) and reintroduced in the
accompanying paper, which determines whether or not the spike
intervals are drawn alternatingly from different distributions.  To
perform the parameter scans we created a new NEURON tool the Multiple
Run Control which can be used to easily set up a parameter scan and
write the simulation results to file. In the directory /hoc/mrc a
separate readme describe the usage of the multiple run control can be
found.

    
Main scientific result of the accompanying paper:

The arrival time of the return current, as measured provisionally by
the average electrotonic path length, determines whether the pyramidal
cell (with ping-pong model dynamics) will burst or fire single
spikes. This goes against the common belief that input conductance is
the determining physical parameter, as we explicitly show .
    
    
Organization of the code:

The code has been adapted from the original code to guard against
starting up time consuming simulations, to achieve this we limited the
run time and the number of points included in the scans. More
specifically we have often disabled the scanning of parameters using
dendritic stimulation, this can easily be switched back on, either
using the Multiple Run Control GUI popping up or by editing the
scripts . Furthermore we have only included part of the code used for
the paper, we were lead by three considerations for including code: is
it needed to reproduce the main findings of the paper, are there
algoritmic details involved important for checking the result, does it
demonstrate an important feature of the Multiple Run Control. If the
answer to one of these questions was yes we included the code.
    
Howto rerun some of the original experiments:
    Make sure a compiled version of the mod-files is available in the
    simulations directory. Start a terminal and cd to simulations
    directory.  (Indicated times where needed for running the code
    using NEURON 7.0 on a 1.86 GHz, (8 core), 2.5 GB computer, using
    linux kernel 2.6.30)
    
    Warning: Because of the parameter and time scans involved
    rerunning the experiments is time consuming, especially the
    parameter scans run on the simplified topologies, can easily take
    days and in the case of the meta parameters scans, despite
    application of poormans paralization, the whole experiment easily
    takes a week.

    Pruning (Figure 3):

        Part I: `Producing spike data and membrane voltage traces
        (This step may take about 40-60 minutes.)
            step 1: nrngui Pruning.ses
            step 2: On the multiple run control press `Loop Run'
            step 3: type quit() on the command line or use NEURON 
                    file menu to quit NEURON.
        Part II: Analysing the data
            step 4: start matlab and open and run Pruning.m in the
                    simulations directory
        Remarks:
            - Full figure reproduction requires generation of traces
            under dendritic stimulation aswell. On the multiple run
            control press `Loop Params', select `Edit' and double
            click on `bDendriticStimulation' and change the numbers
            from `0 0 1 0 0 0' to `0 1 1 0 0 0'. Before pressing the
            `Loop Run' button again make sure to empty the
            Pruning\Results directory.
            - Postscript figures of all the morphologies will
            generated if in the Pruning.ses script bPrintTree is set
            to 1.
            - Figure 301 shows pooled unaveraged data, Figure 302
            shows unaveraged data per seed sequence.

    ScalingReconstructed (Figure 4):
        Part I: `Producing spike data and membrane voltage traces
                (This step may take about 1 hours.)
            step 1: nrngui ScalingReconstructed.ses
            step 2: On the multiple run control press `Loop Run' 
            step 3: type quit() on the command line or use NEURON file
            menu to quit NEURON.
        Part II: Analysing the data
            step 4: start matlab and open and run
            ScalingReconstructed.m in the simulations directory
        Remarks:
            - Full figure reproduction requires generation of traces
            under dendritic stimulation aswell, this takes about (6
            hours). On the multiple run control press `Loop Params',
            select `Edit' and double click on `bDendriticStimulation'
            and change the numbers from `0 0 1 0 0 0' to `0 1 1 0 0
            0'. Before pressing the `Loop Run' button again make sure
            to empty the Pruning\Results directory.  - Postscript
            figures of all the morphologies will generated if in the
            Pruning.ses script bPrintTree is set to 1.  - Figure 401
            how frequency depends on the length scaling factor:
            L-factor

    ReReconstructedCells (Figure 5 and 12):
        Part I: `Producing spike data and membrane voltage traces
                (This step make take about 30 minutes.)
            step 1: nrngui  ReReconstructedCells.ses
            step 2: On the multiple run control press `Loop Run' 
            step 3: type quit() on the command line or use NEURON file
            menu to quit NEURON.
        Part II: `Calculate physical quantities characterizing the
        morphology mean electronic path length, input conductance,
        dendritic membrane area (This step takes a couple of minutes.)
            step 4: nrngui  ReReconstructedCellsIC.ses
            step 5: On the multiple run control press `Loop Run' 
            step 6: type quit() on the command line or use NEURON file
            menu to quit NEURON.
        Part III: Analysing the data
            step 7: start matlab and open and run
            ReReconstructedCells.m in the simulations directory
        Remarks:
            - Full figure reproduction requires generation of traces
            under dendritic stimulation aswell, takes about 1-2
            hours. On the multiple run control press `Loop Params',
            select `Edit' and double click on `bDendriticStimulation'
            and change the numbers from `0 0 1 0 0 0' to `0 1 1 0 0
            0'. Before pressing the `Loop Run' button again make sure
            to empty the ReReconstructedCells\Results directory.
            - Postscript figures of all the morphologies will
              generated if in the ReReconstructedCells.ses script
              bPrintTree is set to 1.
            - Figure 501 shows spikes from the full runs top 7 with
            somatic stimulation, bottom 7 dendritic stimulation.
            - Figure 1201 shows how bursting depends on the tree
            (TreeNumber = Index denoting a tree) and figure 1202 shows
            how frequency depends on the tree.

    simplifiedTopologies obeying Rall's law (Figure 6, 7, 10):
        Part I: `Producing spike data and membrane voltage traces
        (This part takes about 2 days, unless you slice it and split
        it over more processors,see below.)
            step 1: nrngui  simplifiedTopologies.ses
            step 2: On the multiple run control press `Loop Run' 
            step 3: type quit() on the command line or use NEURON file
            menu to quit NEURON.
        Part II: `Calculate physical quantities characterizing the
        morphology mean electronic path length, input conductance,
        dendritic membrane area (This step takes a couple of minutes.)
            step 4: nrngui  simplifiedTopologiesIC.ses
            step 5: On the multiple run control press `Loop Run' 
            step 6: type quit() on the command line or use NEURON file
            menu to quit NEURON.
        Part III: `Generate membrane potential traces I. (This part
        takes about 30 minutes)
            step 7: nrngui   simplifiedTopologiesVTraces.ses 
            step 8: On the multiple run control press `Loop Run' 
            step 9: type quit() on the command line or use NEURON file menu
            to quit NEURON.
        Part IV: `Generate membrane potential traces II. (This part
        takes about 15 minutes)
            step 10: nrngui   simplifiedTopologiesVTraces.ses 
            step 11: On the multiple run control press `SetBasename
            for Output Files' and insert "_T1" after "/Sim" and before
            "_Vtraces" and `Accept'.
            step 12: On the multiple run control press `Loop Params'
            and select `Edit'. Double `currentTopologyNo' and change
            `1 23 1 0 0 0' to `1 1 1 0 0 0' and `Accept'. Then double
            click `totalDendriticLength' and change `1750 1900 150 0 0
            0' to `1000 4000 100 0 0 0' and `Accept'.
            step 13: On the multiple run control press `Loop Run' 
            step 14: type quit() on the command line or use NEURON
            file menu to quit NEURON.
        Part V: Analysing the data
            step 15: start matlab and open and run
            simplifiedTopologies.m in the simulations directory
        Remarks:
            - figure 1001 and 1002 show for the same simulation
            results, burstMeasure (1001) and frequency (1002) plotted
            without offset and as a function of several physical
            quantities characterizing the morphology. Because the
            diameters fit Rall's law all these physical parameters
            have a similar developemnt and it is hard to tease out
            which parameter is the most relevant.

    simplifiedTopologies with constant diameter (Figure 8, 9 ):
        Part I: `Producing spike data and membrane voltage traces
        (This part takes about 8 hours, unless you slice it and split
        it over more processors, see below.)
            step 1: nrngui  simplifiedTopologiesDConst.ses
            step 2: On the multiple run control press `Loop Run' 
            step 3: type quit() on the command line or use NEURON file
            menu to quit NEURON.
        Part II: `Calculate physical quantities characterizing the
        morphology mean electronic path length, input conductance,
        dendritic membrane area (This step takes a couple of minutes.)
            step 4: nrngui  simplifiedTopologiesDConstIC.ses
            step 5: On the multiple run control press `Loop Run' 
            step 6: type quit() on the command line or use NEURON file
            menu to quit NEURON.
        Part V: Analysing the data
            step 15: start matlab and open and run
            simplifiedTopologies.m in the simulations directory
        Remarks: 
            - figure 901 and 902 show the same comparison as in figure
            9 but with dendritic area included for both burst measure
            (901) and frequency (902). Outside the bursting region
            input conductance is the best predictor of firing
            frequency.
            - figure 903 and 904 show for the same simulation results,
            burstMeasure (1001) and frequency (1002) plotted without
            offset and as a function of several physical quantities
            characterizing the morphology.

    Meta scan over simplifiedTopologies obeying Rall's law (Code used
    for producing Supplementary Figures 4,5,6,7):
        
        For these supplementary figures we produced 64 scsans of the
        type described just before, each scan takes about 2 days so
        clearly some kind of parallelization is needed to pull this
        off in reasonable time.
        
        Rather than reproducing the full figure we therefore show here
        how this paralellization was achieved using the
        MultipleRunControl, and give scripts that with slight
        adjusments can be used to recreate the full figures.
        
        Part I: `Producing spike data and membrane voltage traces
        (This reduced scan takes about 40 minutes, full scan takes
        several days.)
            step 1: run the shell script runparallel.sh ()
            step 2: On the multiple run control press `Loop Run' 
            step 3: type quit() on the command line or use NEURON file
            menu to quit NEURON.
        Part II:  Analysing the data
            step 4: start matlab and open and run
            simplifiedTopologiesGKCaGActScanPanels.m in the
            simulations directory
        Remarks:
            - Full figure reproduction requires adjustment of the
            ranges of topologies and lengths scanned and takes several
            days. In the files
            simplifiedTopologiesGKCaGActScanPanels.ses and
            simplifiedTopologiesGKCaGActScanPanels.m it is indicated
            what the original parameters where. Given the relative
            insensitivity of the dynamics to the amount of KCa and Km
            ionchannels, we have only included the extremes of their
            ranges in this example.
            - Numbering of figures in matlab reflects that these
            figures can be seen as figures supporting figure 6 and 7.

References:

    (1) Mainen ZF, Sejnowski TJ (1996) Influence of dendritic
    structure on firing pattern in model neocortical neurons. Nature
    382:363-6
    
    (2) Duijnhouwer, J., Remme, M. W. H., Van Ooyen, A., and Van Pelt,
    J.  (2001). Influence of dendritic topology on firing patterns in
    model neurons. Neurocomputing 38-40: 183-189.
    
    (3) Van Ooyen, A., Duijnhouwer, J., Remme, M. W. H., and Van Pelt,
    J.  (2002). The effect of dendritic topology on firing patterns in
    model neurons. Network: Computation in Neural Systems 13: 311-325.
    
    (4) Van Elburg, R. A. J., and Van Ooyen, A. (2004). A new measure
    for bursting. Neurocomputing 58-60: 497-502.
