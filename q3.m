
close all
x = xolotl.examples.neurons.BurstingNeuron; 

x.manipulate_plot_func = {@(x) q3plot(x,'KCa')};

x.manipulate({'AB.Ca'; 'I_ext';'AB.KCa.gbar'})