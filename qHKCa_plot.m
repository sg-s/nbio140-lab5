function qHCa_plot(x, channel)

x.closed_loop = false;

KCa = @(V,Ca) (Ca/(Ca+3.0))./(1.0+exp((V+28.3)./-12.6));
HCurrent = @(V,Ca, Vhalf) 1.0./(1.0+exp((V-Vhalf)./5.5));
Vspace = -150:150;


I_ext_value = x.I_ext(1);

% inject current from 0.1 to 0.5 seconds
I_ext = zeros(x.t_end/x.sim_dt,1);
I_ext((100/x.sim_dt):(500/x.sim_dt)) = I_ext_value;
x.I_ext = I_ext;

if isfield(x.handles,'fig') 
	% figure exists

else
	x.handles.Ca0 = x.AB.Ca;

	% make figure
	x.handles.fig = figure('outerposition',[3 3 1800 1201],'PaperUnits','points','PaperSize',[1800 1201],'Color','w'); hold on



	x.handles.ax = [];
	x.handles.plots = [];

	x.handles.ax.minf1 = subplot(2,3,1); hold on
	set(gca,'FontSize',16)
	x.handles.ax.minf1.YLim = [-.01 1];
	x.handles.ax.minf1.XLim  = [-150 100];
	x.handles.ax.minf2 = subplot(2,3,4); hold on
	set(gca,'FontSize',16)
	x.handles.ax.minf2.YLim = [-.01 0.03];
	x.handles.ax.minf2.XLim  = [-150 100];

	x.handles.ax.V = subplot(3,3,2:3); hold on
	x.handles.ax.V.YLim = [-100 50];
	set(gca,'FontSize',16)
	x.handles.ax.I = subplot(3,3,5:6); hold on
	set(gca,'FontSize',16)
	x.handles.ax.Ca = subplot(3,3,8:9); hold on
	set(gca,'FontSize',16)

	xlabel(x.handles.ax.minf1,'Voltage (mV)')
	ylabel(x.handles.ax.minf1,['m_{\infty} (HCurrent)'])
	xlabel(x.handles.ax.minf2,'Voltage (mV)')
	ylabel(x.handles.ax.minf2,['m_{\infty} (KCa)'])
	xlabel(x.handles.ax.Ca,'Time (s)')
	ylabel(x.handles.ax.Ca,'[Ca^2^+]')
	ylabel(x.handles.ax.V,'V_m (mV)')
	ylabel(x.handles.ax.I,'Injected Current (nA)');

	[V,Ca] = x.integrate;
	time = (1:length(V))*x.dt*1e-3;
	x.handles.plots.V = plot(x.handles.ax.V,time,V,'k','LineWidth',2);
	x.handles.plots.I = plot(x.handles.ax.I,time,I_ext,'k','LineWidth',2);
	x.handles.plots.Ca = plot(x.handles.ax.Ca,time,Ca(:,1),'k','LineWidth',2);

	minf1 = HCurrent(Vspace,0.05,-75);
	minf2 = KCa(Vspace,0.05);

	x.handles.plots.minf1 = plot(x.handles.ax.minf1,Vspace,minf1,'k','LineWidth',2);
	x.handles.plots.minf2 = plot(x.handles.ax.minf2,Vspace,minf2,'k','LineWidth',2);

	x.handles.ax.minf2.Visible = 'off';
	x.handles.plots.minf2.Color = 'w';
end


% update the m_inf curves

minf1 = HCurrent(Vspace, 0.05,x.AB.HCurrent.Vhalf);
minf2 = KCa(Vspace,x.AB.Ca);
x.handles.plots.minf1.YData = minf1;
x.handles.plots.minf2.YData = minf2;

x.AB.Ca = x.handles.Ca0;
[V,Ca] = x.integrate;

% update plots
x.handles.plots.Ca.YData = Ca(:,1);
x.handles.plots.V.YData = V;
x.handles.plots.I.YData = I_ext;

x.I_ext = I_ext(101/x.sim_dt);
