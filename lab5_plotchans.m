function lab5_plotchans

KCa = @(V,Ca) (Ca/(Ca+3.0))./(1.0+exp((V+28.3)./-12.6));
HCurrent = @(V,Vhalf) 1.0./(1.0+exp((V-Vhalf)./5.5));
KCa_tau = @(V) 180.6 - 150.2./(1.0+exp((V+46.0)/-22.7));
HTau = @(V) 2000+0*V;


alpha_m = @(V) (1e5*(-V/1000-0.045))./(exp(100*(-V/1000-0.045))-1);
beta_m = @(V) 4000*exp((-V/1000-0.070)/0.018);   % Sodium deactivation rate
alpha_h = @(V) 70*exp(50*(-V/1000-0.070));       % Sodium inactivation rate
beta_h = @(V) 1000./(1+exp(100*(-V/1000-0.040))); % Sodium deinactivation rate

alpha_n = @(V) (1e4*(-V./1000-0.060))./(exp(100*(-V/1000-0.060))-1);
beta_n = @(V) 125*exp((-V/1000-0.070)/0.08);     % potassium deactivation rate

tau_m = @(V) 1000./(alpha_m(V)+beta_m(V));  % units: ms
minf = @(V) alpha_m(V)./(alpha_m(V)+beta_m(V));

tau_h = @(V) 1000./(alpha_h(V)+beta_h(V)); % units: ms
hinf = @(V) alpha_h(V)./(alpha_h(V)+beta_h(V));

tau_n = @(V) 1000./(alpha_n(V)+beta_n(V)); % units: ms
ninf = @(V) alpha_n(V)./(alpha_n(V)+beta_n(V));

exponents = { [3 1], [1 1], [4], [1], [1], [1], [4 4], [1 1] };
tau_mult = [1e-3 1e-3 1 1]; % convert to ms

chfun = { 	{'minf(Vm)','hinf(Vm)'}, {'tau_m(Vm)','tau_h(Vm)'}, ...  % fast sodium
		{'ninf(Vm)'}, {'tau_n(Vm)'}, ....% delayed rectifier potassium
		{'HCurrent(Vm,-85)'}, {'HTau(Vm)'}, ... % Hcurrent
		{'KCa(Vm,0.05)', 'KCa(Vm,0.5)'}, {'KCa_tau(Vm)', 'KCa_tau(Vm)'}}; % KCa current

colors = { {'m','g'}, {'m','g'}, ... % fast sodium
	   {'y'}, {'y'}, ... % delayed rectifier potassium
	   {'b'}, {'b'}, ... % Hcurrent
	   {[0.25 0 0]  [1 0 0]} {[0.25 0 0]  [1 0 0]} }; % KCa Current

legend_text = { {'Na pore','Na inact'}, {}, {'Kd pore'}, {}, ...
	 {'H pore'}, {}, {'KCa pore (low Ca)','KCa pore (high Ca)'},{}};

title_text = {'Fast Na','Fast Na','K-delayed rectifier','K-delayed rectifier',...
	'H','H','KCa','KCa'};

Vm = -150:150 + 0.5;

start = [1 5];

for i=1:numel(start),
	figure;
	for j=start(i):start(i)+3,
		subplot(2,2,j-start(i)+1);
		set(gca,'fontsize',16);
		for k=1:numel(chfun{j}),
			y = eval([chfun{j}{k} ';']);
			y = power(y,exponents{j}(k));
			c = colors{j}{k};
			if ischar(c),
				plot(Vm,y,['-' c],'linewidth',2);
			else,
				plot(Vm,y,'color',c,'linewidth',2);
			end;
			hold on;
		end;

		if mod(j,2),
			ylabel({'Open probability','(steady state)'});
		else,
			ylabel('Time constant (ms)');
			legend(legend_text{j-1});
		end;
		xlabel('Voltage (mV)');
		box off;
		title(title_text{j});
	end;
end;

for i=5:numel(chfun), % figure 2, H and KCa



end;
