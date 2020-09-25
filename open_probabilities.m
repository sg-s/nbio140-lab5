function open_probabilites()

	% get gating functions for channels
	channels = {'NaV','Kd','KCa','HCurrent'};
	for i = 1:length(channels)
		[m_inf.(channels{i}), h_inf.(channels{i}), tau_m.(channels{i}), tau_h.(channels{i})] =  xolotl.getGatingFunctions(['prinz/' channels{i}]);
	end

	% tau_m for H is borked, fix
	tau_m.HCurrent = @(V,Ca) 2e3;


	% plot NaV, Kd
	plotFcn = {m_inf.NaV, h_inf.NaV, tau_m.NaV, tau_h.NaV, m_inf.Kd, tau_m.Kd};
	Colors =  {'g',       'm',         'g',         'm',        'y',    'y'};
	Exponents = [3         1           1             1           4       1 ];
	plot_here = [1         1           2             2           3       4];
	Titles = {'Fast Na','Fast Na','Fast Na','Fast Na','K delayed rectifier','K delayed rectifier'};

	ax = makeFig;
	makePlots(ax,plotFcn,Exponents,Colors,plot_here,Titles)


	% plot KCa, HCurrent
	plotFcn = {m_inf.HCurrent,  tau_m.HCurrent, m_inf.KCa, m_inf.KCa, tau_m.KCa};
	Colors =  {'b',               'b',            'r',      'k' ,       'r'};
	Exponents = [1                 1              4          4           1];
	plot_here = [ 1                2              3          3           4];
	Titles = {'H',                'H',           'KCa',    'KCa',      'KCa'};
	Calcium = [0                   0              .05        30         .05];

	ax = makeFig;
	makePlots(ax,plotFcn,Exponents,Colors,plot_here,Titles,Calcium)


end



function ax = makeFig()

	figure('outerposition',[300 300 600 600],'PaperUnits','points','PaperSize',[600 600],'Color','w'); hold on
	for i = 1:4
		ax(i) = subplot(2,2,i);
		hold on
		set(gca,'FontSize',16)
		xlabel('Voltage (mV)')
		if rem(i,2) == 1
			ylabel({'Open probability','(steady state)'})
		else
			ylabel('Time scale (ms)')
		end
	end
end



function makePlots(ax,plotFcn,Exponents,Colors,plot_here,Titles,Calcium)
	if ~exist('Calcium','var')
		Calcium = NaN(length(plotFcn),1);
	end
	Vspace = -80:50;
	for i = 1:length(plotFcn)
		y = NaN*Vspace;
		for j = 1:length(y)
			y(j) = plotFcn{i}(Vspace(j),Calcium(i));
		end
		y = y.^Exponents(i);
		plot(ax(plot_here(i)),Vspace,y,'Color',Colors{i},'LineWidth',2);
		title(ax(plot_here(i)),Titles{i})
	end
end