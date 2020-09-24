close all
clearvars

x = xolotl.examples.neurons.BurstingNeuron; 

x.t_end = 5e3;

% swap out HCurrent
x.AB.HCurrent.destroy()
x.AB.add('generic/HCurrent');


% fine tune some parameters to get a rebound burster
x.AB.Leak.gbar = .074;
x.AB.KCa.gbar = 50;
x.AB.HCurrent.Vhalf = -85;
x.AB.HCurrent.gbar = .5;
x.AB.CaT.gbar = 20;
x.AB.CaS.gbar = 20;

x.manipulate_plot_func = {@(x) qHKCa_plot(x,'HCurrent')};

% use this to fine tune parameters
% x.manipulate([{'AB.Ca'; 'I_ext';'AB.HCurrent.Vhalf'}; x.find('*gbar')])

x.manipulate({'AB.Ca'; 'I_ext';'AB.HCurrent.gbar';'AB.HCurrent.Vhalf';'AB.KCa.gbar'})
