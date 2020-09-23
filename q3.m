
close all
x = xolotl.examples.neurons.BurstingNeuron; 

x.manipulate_plot_func = {@q3plot};

x.manipulate({'AB.Ca'; 'I_ext';'AB.KCa.gbar'})