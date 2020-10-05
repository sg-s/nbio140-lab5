
% create a 3-cell pyloric network
x = xolotl.examples.networks.pyloric();

% download the binary
x.download;

x.manipulate('AB.*gbar')

% cosmetic fixes
for i = 1:length(x.handles.plots)
	x.handles.plots(i).ph.LineWidth = .5;
end