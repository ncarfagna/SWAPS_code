SWAPS (Surface Waves dispersion Analysis from Pairs of Sensors)

MATLAB code for the univocal extraction of the surface wave phase dispersion curve from ambient noise recorded at a pair of sensors

Version: v1.0.1
Latest Vesion: v1.0.1 

----------------------------------------------------------------
----------------------------------------------------------------

The following provides key information about the SWAPS software, designed for the extraction of both phase and group dispersion curves using pairs of sensors. The program is freely available and accessible to all users, including researchers, academics, and independent professionals. A more comprehensive description of its functionality is provided in the associated article.

In what follows, you will find a brief description of how the program is structured, an overview of the main processing steps—from the import of input data to the extraction of dispersion curves—and a summary of the key functions involved throughout the workflow.

For any questions, feedback, or remarks, feel free to reach out to:

nicolo.carfagna@student.unisi.it

----------------------------------------------------------------
----------------------------------------------------------------

Inside the directory SWAPS, there are two subdirectories:

 - Code: This folder contains the complete source code of the program, including the main script 'start_SWAPS.m', which launches all the routines located in the 'functions' subfolder.
 - Example: This folder includes two files, 'receivers.txt' and 'signals.txt', which respectively contain information about the seismic stations and the seismic traces to be analyzed. The file 'receivers.txt' contains, on each line, the station name followed by the x and y coordinates, expressed in metric units (either absolute or relative — both are acceptable). The file 'signals.txt' contains the seismic traces, with each column representing a channel. In this view, the first column corresponds to the seismic trace recorded at the station listed in the first line of 'receivers.txt', the second column to the second station, and so on.
The subdirectory Example also contains the folder 'results' with examples of dispersion analysis outputs generated using SWAPS.

To run SWAPS correctly, the two input files — receivers.txt and signals.txt, which contain the station and trace data and can be renamed as desired — must be placed in the same directory as the main script start_SWAPS.m and the functions folder. Once this setup is complete, you can proceed to run SWAPS.

When SWAPS is launched, the user is initially presented with two options:

 - Perform a new dispersion analysis (on two or more stations), or
 - Create a summary file based on one or more analyses previously performed and stored within a project folder.

In the latter case, a summary file will be generated, collecting all phase dispersion curves obtained from the selected past analyses. After creating the summary file, an interactive window will open, allowing the user to visualize and explore all the collected curves based on the spatial arrangement of the stations.

In the first case a normal dispersion analysis (between two or more stations) can be computed. Below is an overview of the program workflow, from importing input files to extracting dispersion curves and exporting them as output. For a more in-depth understanding, please refer to the article associated with the program, published in Computer & Geosciences.


----------------------------------------------------------------
----------------------------------------------------------------


BRIEF DESCRIPTION OF SWAPS WORKFLOW


IMPORTING TRACES AND STATION DATA

Once the input files have been placed in the same directory as start_SWAPS.m and the functions folder, and the program has been launched, clicking the 'Select Input' button will allow the user to first select the station file, followed by the seismic trace file. These files may have different names than those used in the example.
At this stage, two interactive windows will appear:

 - The first allows the user to select which traces to analyze (two or more);
 - The second allows the user to define the time windows over the whole traces on which the analysis will be performed.

FREQUENCY AND TIME-DOMAIN ANALYSIS

Once the traces have been imported and the time windows selected, average cross-correlation and coherence functions are computed across all selected windows and displayed in the program’s main interface.
Both frequency- and time-domain analyses can be repeated multiple times by adjusting the available parameters to better suit the specific context.
Phase dispersion curves can be extracted using either manual or automatic picking. Once a phase picking has been performed, a corresponding synthetic group velocity curve can be plotted on top of the frequency–group velocity plot generated from the time-domain analysis. Multiple phase dispersion curves can be selected one at a time, allowing the user to evaluate the fit between the FTAN analysis results and the corresponding synthetic group velocity curves.
Each time a new picking is performed—either manual or automatic—upper and lower boundary curves are estimated for the selected phase dispersion curve, representing uncertainty bounds at each frequency.

SAVING RESULTS 

Once the most suitable phase dispersion curve has been selected, the results can be saved by clicking the 'Save' button. A new project can be created in the form of a new directory, within which a subdirectory corresponding to the current analysis will be generated.
If a project folder already exists, it can be selected, and a new subdirectory containing the current analysis results will be created within it. The following results can be saved:

 - Experimental phase dispersion curve
 - Experimental group dispersion curve
 - Synthetic group dispersion curve
 - Cross-correlation function
 - Coherence function

If the user chooses to save the experimental group velocity curve, an additional window will appear, allowing manual picking of the group curve. Both the phase and group experimental curves will be saved as linearly interpolated curves at a frequency step of 0.5 Hz (i.e., 0.5 – 1.0 – 1.5 – 2.0 – 2.5, and so on), based on the selected endpoints.


----------------------------------------------------------------
----------------------------------------------------------------


LIST OF MAIN FUNCTIONS IN THE FUNCTIONS DIRECTORY
Beow is a list of the main routines included in the functions folder, each accompanied by a brief description of its purpose, along with the expected input and output parameters.


select_data_new.m
Used to select the stations to analyze and define the sampling frequency for the measurements.


import_sig_sta_new.m
Used to select time windows on the seismic traces based on parameters chosen interactively by the user, including start and end times, window width and overlap, and an amplitude threshold for window rejection.


cross_cohe.m
Function that internally calls crosscorr_2.m and coherence_2.m, which compute the average cross-correlation function and the average coherence function, respectively, across all previously selected time windows. It also calls splineLSQR.m to smooth the coherence function. It takes all time windows as input.


f_SN.m
Used during coherence computation to further refine the selection of time windows. For each window, the amplitude spectrum is computed, and frequency by frequency, windows with extreme amplitudes (either too low or too high) are discarded. This ensures a more stable average coherence function.


splineLSQR.m
Called during coherence computation. After raw coherence function is calculated, it is replaced by a smoothed version obtained through a linear combination of spline functions, improving curve smoothness and stability.


FTAN_general.m
Calls the FTAN.m and FTAN_fold.m functions to perform multi-filter analysis on the causal, acausal, and folded parts of the cross-correlation function (CCF). Returns frequency–group velocity diagrams used for manual or automatic picking. Inputs include parameters for the Gaussian filter and frequency step of the filter.


space_corr_win.m
Used when more than two traces are selected. It builds the frequency–phase velocity fit space by dividing the average coherence function into a set of overlapping windows. A Bessel function-based fitting procedure is applied to each window. Parameters like frequency window width and step, as well as fitting coefficients, are defined in advance and cannot be modified afterward.


space_corr_win_2.m
Used when only two traces are selected. Produces the same output as space_corr_win.m, but frequency window width and step can be dynamically adjusted to modify resolution, and fitting coefficients can be changed to emphasize correlation over RMS (or vice versa).


auto_pick.m
Performs automatic picking of the phase dispersion curve. It takes as input the frequency and velocity vectors, along with a 2D matrix of fit values for each frequency–phase velocity pair. The function returns the selected dispersion curve, including automatically estimated upper and lower confidence bounds. The user dynamically defines the start and end points of the picking range.


auto_pick_multi.m
Uses the same picking algorithm as auto_pick.m, but it's designed for cases where more than two stations are selected. Inputs and outputs are the same as auto_pick.m, but the frequency limits for the dispersion curve are fixed at the beginning and cannot be adjusted.


getPick.m
Allows manual picking of phase dispersion curves in the frequency-phase velocity plot.


auto_pickGr.m
Performs automatic picking in the frequency–group velocity domain when more than two stations are selected. In contrast, group velocity picking is done manually when only two receivers are involved.


get_Vg.m
Generates synthetic group velocity curves based on manually or automatically picked phase dispersion curves. These synthetic curves are used to compare with experimental group curves to identify the best-fitting phase curve.


error_v.m
Called during both manual and automatic picking for phase and group curves. It computes upper and lower error bars for the selected dispersion curve. Inputs include a potential dispersion curve and the corresponding 2D fit matrix; outputs are the upper and lower uncertainty curves.


multi_plot_win_bis.m
Can be launched at program startup as an alternative to running a new analysis. If results already exist, they can be selected from a shared folder and displayed in an interactive window, allowing detailed inspection of phase dispersion curves.

