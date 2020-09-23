function q23plot(x, channel)


x.closed_loop = false;


KCa = @(V,Ca) (Ca/(Ca+3.0))./(1.0+exp((V+28.3)./-12.6));
HCurrent = @(V,Ca, Vhalf) 1.0./(1.0+exp((V-Vhalf)./5.5));
Vspace = -80:50;


% inject current for half a second
I_ext = zeros(x.t_end/x.sim_dt,1);
I_ext(1:(500/x.sim_dt)) = x.I_ext;
x.I_ext = I_ext;

if isfield(x.handles,'fig') 
	% figure exists

else


	x.handles.Ca0 = x.AB.Ca;

	% make figure
	x.handles.fig = figure('outerposition',[3 3 1200 600],'PaperUnits','points','PaperSize',[1200 600],'Color','w'); hold on

	x.handles.ax = [];
	x.handles.plots = [];

	x.handles.ax.minf = subplot(2,3,1); hold on
	set(gca,'FontSize',16)
	x.handles.ax.minf.YLim = [-.01 1];
	x.handles.ax.minf.XLim  = [-80 50];
	x.handles.ax.V = subplot(2,3,2:3); hold on
	set(gca,'FontSize',16)
	x.handles.ax.Ca = subplot(2,3,5:6); hold on
	set(gca,'FontSize',16)

	xlabel(x.handles.ax.minf,'Voltage (mV)')
	ylabel(x.handles.ax.minf,['m_{\infty} (' channel ')'])
	xlabel(x.handles.ax.Ca,'Time (s)')
	ylabel(x.handles.ax.Ca,'[Ca^2^+]')
	ylabel(x.handles.ax.V,'V_m (mV)')

	[V,Ca] = x.integrate;
	time = (1:length(V))*x.dt*1e-3;
	x.handles.plots.V = plot(x.handles.ax.V,time,V,'k');


	x.handles.plots.Ca = plot(x.handles.ax.Ca,time,Ca(:,1),'k');

	switch channel
	case 'KCa'
		minf = KCa(Vspace,.05);
	case 'HCurrent'
		minf = HCurrent(Vspace,.05,-75);
	end
	
	x.handles.plots.minf = plot(x.handles.ax.minf,Vspace,minf,'k');



end


% update the KCa m_inf curve
switch channel
case 'KCa'
	minf = KCa(Vspace,.05);
case 'HCurrent'
	minf = HCurrent(Vspace,.05,x.AB.HCurrent.Vhalf);
end
x.handles.plots.minf.YData = minf;


x.AB.Ca = x.handles.Ca0;
[V,Ca] = x.integrate;

% update plots
x.handles.plots.Ca.YData = Ca(:,1);
x.handles.plots.V.YData = V;


x.I_ext = I_ext(1);