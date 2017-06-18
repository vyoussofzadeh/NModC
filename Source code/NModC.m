% Copyright (c) 2016-17
% Written by Alok Joshi, Vahab Youssofzadeh, Vinith Vemana, and KongFatt Wong-Lin
% Corresponding Author: KongFatt Wong-Lin <k.wong-lin@ulster.ac.uk>
% Last modified: 15-Dec-2016 
%%  
% NModeC” is a MATLAB GUI for analyzing the time evolution of proposed 
% hybrid model where three interacting brain regions LHA, LC and DRN are 
% modulated by orexin, norepinephrine and serotonin (5-HT) neurochemicals,
% respectively. The general idea is that a typical post synaptic neuron is
% indirectly influenced by a single presynaptic partner through one or 
% more neurotransmitters that regulate diverse populations of neurons 
% in the nervous system. The starting window of GUI “NModeC” after 
% pressing ‘Start’ button exhibits changes of model outputs of three 
% interacting brain areas over time. The outputs are the firing rate 
% of three sources that are normalized in the range of [0, 1] and 
% translated into color map in the range of [0, 255], where red represents
% the highest and blue represents the lowest firing rates, respectively. 
% For easy interpretation, three regions are presented in a rough location
% based on their MNI coordinates overlaid on a glass brain. The 3D 
% rotation of the brain is also allowed. The simple but fast Euler method
% with a time step equal to 1 millisecond was employed to solve the state
% equations consist of 16 first order differential equation. Once the 
% model is converged, the ‘Outputs’ button can provide the outputs for 
% each area consist of concentration (release-and-reuptake/decay) dynamics
% and firing rate of each source with respect to time or firing rates from
% two other sources. The model parameters can be edited and by pressing
% ‘Simulate’ and ‘Outputs’ buttons, the corresponding results can be seen
% in both main window and the model outputs, respectively. Finally, the
% ‘Default’ button returns the default values of model parameters.
%% 
% Disclaimer: The authors have written this software in a good faith for
% educational and research purposes. This software has a limited scope and
% is based on several assumptions. The authors does not take any legal 
% responsibility for the completeness, accuracy, or usefulness of the 
% software. Moreover, authors are also not responsible for any loss or
% damage incurred due to the generated results or information. Also, 
% the authors would not provide further support for the code, corrections
% or upgrades of the current version of the software. However, if the
% users adapt the similar methodologies in their research they should
% cite our work.

% Joshi, A., Youssofzadeh, V., Vemana, V., McGinnity, T.M., Prasad, G., 
% Wong-Lin, K. An Integrated Multiscale Modelling Framework for Neural 
% Circuits with Multiple Neuromodulators. J. R. Soc. Interface.
%%
function NModC(action)

clc;
% ====== Start of simulation
set(0,'DefaultAxesFontName', 'Calibri Light');
global y P t dt T data A Edt1 Edt2 Tab Sim_scale fig1 fig2 Param

% Runinning time settings
T  = 5;       % 12000 % Total time, in sec
dt = 0.001;   % Time step, in 0.001 sec
t  = 0:dt:T;  % Simulation time 1000 sec
Sim_scale = 10;

A = 0.2*ones(61, 73, 58);
data = load('noeye.mat');

if nargin<1,
    action='initialize';
end;

if strcmp(action,'initialize'),
    fig1 = figure( ...
        'Name','NModC', ...
        'NumberTitle','off', ...
        'DoubleBuffer','on', ...
        'Visible','off', ...
        'Color','white', ...
        'BackingStore','off');
    axes( ...
        'Units','normalized', ...
        'Position',[0.01 0.05 0.75 0.90], ...
        'Visible','off', ...
        'DrawMode','fast', ...
        'Color','none',...
        'NextPlot','add');
    
    text(0,0,{'Press the "Start" button to see the simulations' 'Use the slider to change the number of initial cells.'}, ...
        'HorizontalAlignment','center', 'fontsize', 8);
    axis([-1 1 -1 1]);
    
    %===================================
    % Information for all buttons
    xPos       = 0.85;
    btnLen     = 0.10;
    btnWid     = 0.10;
    % Spacing between the button and the next command's label
    spacing    = 0.05;
    
    %====================================
    % The CONSOLE frame
    frmBorder = 0.02;
    yPos      = 0.05-frmBorder;
    frmPos    = [xPos-frmBorder yPos btnLen+2*frmBorder 0.9+2*frmBorder];
    uicontrol( ...
        'Style','frame', ...
        'Units','normalized', ...
        'Position',frmPos, ...
        'BackgroundColor',[0.50 0.50 0.50]);
    
    %====================================
    % The START button
    btnNumber   = 1;
    yPos        = 0.90-(btnNumber-1)*(btnWid+spacing);
    labelStr    = 'Start';
    callbackStr = 'NModC(''start'');';
    
    % Generic button information
    btnPos    = [xPos yPos-spacing btnLen btnWid];
    startHndl = uicontrol( ...
        'Style','pushbutton', ...
        'Units','normalized', ...
        'Position',btnPos, ...
        'String',labelStr, ...
        'Interruptible','on', ...
        'Callback',callbackStr,...
        'fontsize',8);
    
    %====================================
    % The STOP button
    btnNumber=2;
    yPos=0.90-(btnNumber-1)*(btnWid+spacing);
    labelStr='Stop';
    % Setting userdata to -1 (=stop) will stop the demo.
    callbackStr='set(gca,''Userdata'',-1)';
    
    
    % Generic button information
    btnPos=[xPos yPos-spacing btnLen btnWid];
    stopHndl=uicontrol( ...
        'Style','pushbutton', ...
        'Units','normalized', ...
        'Position',btnPos, ...
        'Enable','off', ...
        'String',labelStr, ...
        'Callback',callbackStr,...
        'fontsize',8);
    
    %====================================
    % The model button
    labelStr='Outputs';
    callbackStr='NModC(''Outputs'')';
    uicontrol( ...
        'Style','push', ...
        'Units','normalized', ...
        'Position',[xPos 0.55 btnLen 0.10], ...
        'String',labelStr, ...
        'Callback',callbackStr,...
        'fontsize',8);
    
    %====================================
    % The parameters button
    labelStr='Parametrs';
    callbackStr='NModC(''Parameters'')';
    infoHndl=uicontrol( ...
        'Style','push', ...
        'Units','normalized', ...
        'Position',[xPos 0.40 btnLen 0.10], ...
        'String',labelStr, ...
        'Callback',callbackStr,...
        'fontsize',8);
    
    %====================================
    % The Close button
    labelStr='Close';
    callbackStr='close all';
    closeHndl=uicontrol( ...
        'Style','push', ...
        'Units','normalized', ...
        'Position',[xPos 0.05 btnLen 0.10], ...
        'String',labelStr, ...
        'Callback',callbackStr,...
        'fontsize',8);
    
    %====================================
    % The Time edit
    uicontrol('Style','text', 'Units','normalized',...
        'BackgroundColor',[0.50 0.50 0.50],...
        'HorizontalAlignment','left',...
        'Position',[xPos 0.34 0.1 0.05],'string','Time [sec]:',...
        'fontsize',8);
    Edt1 = uicontrol('Style','edit', 'Units','normalized', ...
        'Position',[xPos 0.30 btnLen 0.05],...
        'string',num2str(T),...
        'fontsize',8);
    
    %====================================
    % The Simulation scale edit
    uicontrol('Style','text', 'Units','normalized',...
        'BackgroundColor',[0.50 0.50 0.50],...
        'HorizontalAlignment','left',...
        'Position',[xPos 0.24 0.1 0.05],'string','Sim scale:',...
        'fontsize',8);
    Edt2 = uicontrol('Style','edit', 'Units','normalized', ...
        'Position',[xPos 0.20 btnLen 0.05],...
        'string',num2str(Sim_scale),...
        'fontsize',8);
    
    %====================================
    % Uncover the figure
    hndlList=[startHndl stopHndl infoHndl closeHndl];
    set(fig1,'Visible','on', ...
        'UserData',hndlList);
    
    view(3);
    m = 19;
    colormap(jet(m));caxis([0, 1]);
    colorbar;
    
elseif strcmp(action,'start'),
    cla;
    fig1      = gcf;
    hndlList  = get(fig1,'Userdata');
    startHndl = hndlList(1);
    stopHndl  = hndlList(2);
    infoHndl  = hndlList(3);
    closeHndl = hndlList(4);
    set([startHndl closeHndl infoHndl],'Enable','off');
    set(stopHndl,'Enable','on');
    
    %====================================
    % Model priors
    priors;
    
    %====================================
    % model equations
    y = model();
    
    Receptor_Density(y);
    
    set([startHndl closeHndl infoHndl],'Enable','on');
    set(stopHndl,'Enable','off');
    
elseif strcmp(action,'Outputs'),
    
    fig2 = figure(2);
    
    set(fig2,'NumberTitle','off','doublebuffer','on',...
        'Name','DRN outputs',...
        'Units','normalized','toolbar','figure',...
        'Position',[0.05 0.05 0.4 0.3]);
    
    T =  str2double(get(Edt1,'string'));
    t  = 0:dt:T;  % Simulation time 1000 sec
    
    % DRN outputs
    h1  = subplot(2,3,1);
    h2  = subplot(2,3,2);
    h3  = subplot(2,3,3);
    h4  = subplot(2,3,4);
    h5  = subplot(2,3,5);
    h6  = subplot(2,3,6);
    
    subplot(h1); plot(t,y(:,1))       ; xlabel('Time (s)')    ;ylabel('Ox-A_D_R_N (nM)')  ;set(gca, 'Color', 'None'); title({'Orexin-A release and reuptake','dynamics in DRN'});
    subplot(h2); plot(t,y(:,2))       ; xlabel('Time (s)')    ;ylabel('Ox-B_D_R_N (nM)')  ;set(gca, 'Color', 'None'); title({'Orexin-B release and reuptake','dynamics in DRN'});
    subplot(h3); plot(t,y(:,3))       ; xlabel('Time (s)')    ;ylabel('Ne_D_R_N (nM)')    ;set(gca, 'Color', 'None'); title({'Norepinephrine release and reuptake','dynamics in DRN'});
    subplot(h4); plot(t,y(:,14))      ; xlabel('Time (s)')    ;ylabel('f_D_R_N (Hz)')     ;set(gca, 'Color', 'None'); title({'Basal firing rate','of 5-HT neurons in DRN'});
    subplot(h5); plot(y(:,17),y(:,14)); xlabel('f_L_C (Hz)')  ;ylabel('f_D_R_N (Hz)')     ;set(gca, 'Color', 'None'); title({'Basal firing rate','of DRN vs. LC'});
    subplot(h6); plot(y(:,10),y(:,14)); xlabel('f_L_H_A (Hz)');ylabel('f_D_R_N (Hz)')     ;set(gca, 'Color', 'None'); title({'Basal firing rate','of DRN vs. LHA'});
    
     
    % LC output
    fig4 = figure(4);
    
    set(fig4,'NumberTitle','off','doublebuffer','on',...
        'Name','LC outputs',...
        'Units','normalized','toolbar','figure',...
        'Position',[0.05 0.05 0.4 0.3]);
    
    h1  = subplot(2,3,1);
    h2  = subplot(2,3,2);
    h3  = subplot(2,3,3);
    h4  = subplot(2,3,4);
    h5  = subplot(2,3,5);
    subplot(h1); plot(t,y(:,4))       ; xlabel('Time (s)')    ;ylabel('Ox_L_C (nM)')    ;set(gca, 'Color', 'None'); title({'Orexin release and reuptake','dynamics in LC'});
    subplot(h2); plot(t,y(:,5))       ; xlabel('Time (s)')    ;ylabel('5-HT_L_C (nM)')  ;set(gca, 'Color', 'None'); title({'Serotonin release and reuptake','dynamics in LC'});
    subplot(h3); plot(t,y(:,17))      ; xlabel('Time (s)')    ;ylabel('f_L_C (Hz)')     ;set(gca, 'Color', 'None'); title({'Basal firing rate','of NE neurons in LC'});
    subplot(h4); plot(y(:,10),y(:,17)); xlabel('f_L_H_A (Hz)');ylabel('f_L_C (Hz)')     ;set(gca, 'Color', 'None'); title({'Basal firing rate','of LC vs. LHA'});
    subplot(h5); plot(y(:,14),y(:,17)); xlabel('f_D_R_N (Hz)');ylabel('f_L_C (Hz)')     ;set(gca, 'Color', 'None'); title({'Basal firing rate','of LC vs. DRN'});
    
    
    % LHA output
    fig5 = figure(5);
    
    set(fig5,'NumberTitle','off','doublebuffer','on',...
        'Name','LHA outputs',...
        'Units','normalized','toolbar','figure',...
        'Position',[0.05 0.05 0.4 0.3]);
    
    h1  = subplot(2,3,1);
    h2  = subplot(2,3,2);
    h3  = subplot(2,3,3);
    h4  = subplot(2,3,4);
    h5  = subplot(2,3,5);
    subplot(h1); plot(t,y(:,6))       ; xlabel('Time (s)')    ;ylabel('5-HT_L_H_A (nM)') ;set(gca, 'Color', 'None'); title({'Orexin release and reuptake','dynamics in LHA'});
    subplot(h2); plot(t,y(:,7))       ; xlabel('Time (s)')    ;ylabel('Ne_L_H_A (nM)')   ;set(gca, 'Color', 'None'); title({'Serotonin release and reuptake','dynamics in LHA'});
    subplot(h3); plot(t,y(:,10))      ; xlabel('Time (s)')    ;ylabel('f_L_H_A (Hz)')   ;set(gca, 'Color', 'None'); title({'Basal firing rate','of Ox neurons in LHA'});
    subplot(h4); plot(y(:,17),y(:,10)); xlabel('f_L_C (Hz)')  ;ylabel('f_L_H_A (Hz)')    ;set(gca, 'Color', 'None'); title({'Basal firing rate','of DRN vs. LC'});
    subplot(h5); plot(y(:,14),y(:,10)); xlabel('f_D_R_N (Hz)');ylabel('f_L_H_A (Hz)')    ;set(gca, 'Color', 'None'); title({'Basal firing rate','of DRN vs. LHA'});
    
        
elseif strcmp(action,'Parameters'),
    
    fig3 = figure(3);
    
    set(fig3,'NumberTitle','off','doublebuffer','on',...
        'Name','Parameters',...
        'Units','normalized','toolbar','figure',...
        'Position',[0.6 0.05 0.3 0.7]);
    
    % The default params button
    labelStr = 'Default';
    callbackStr = 'NModC(''Default'')';
    uicontrol( ...
        'Style','push', ...
        'Units','normalized', ...
        'Position',[0.08 0.01 0.10 0.05], ...
        'String',labelStr, ...
        'Callback',callbackStr);
    
    % The Edit/Update params button
    labelStr = 'Simulate';
    callbackStr = 'NModC(''Simulate'')';
    uicontrol( ...
        'Style','push', ...
        'Units','normalized', ...
        'Position',[0.2 0.01 0.1 0.05], ...
        'String',labelStr, ...
        'Callback',callbackStr);
    
    Param = {
        'OxRelease_A_DRN    ' P.OxRelease_A_DRN      'NM    '    'Basal Orexin levels in DRN                          '
        'OxRelease_B_DRN    ' P.OxRelease_B_DRN      'NM    '    'Basal Orexin levels in DRN                          '
        'Ne_DRN             ' P.Ne_DRN               'NM    '    'Basal Norepinephrine levels in DRN                  '
        'fDRN               ' P.fDRN                 'Hz    '    'Basal firing rate of DRN neurons                    '
        'OxRelease_A_LC     ' P.OxRelease_A_LC       'NM    '    'Basal Orexin levels in LC                           '
        'FiveHT_LC          ' P.FiveHT_LC            'NM    '    'Basal Serotonin (5-HT) levels in LC                 '
        'fLC                ' P.fLC                  'Hz    '    'Basal firing rate of orexin neurons in LC           '
        'FiveHT_LHA         ' P.FiveHT_LHA           'nM    '    'Basal Serotonin (5-HT)levels in LC                  '
        'Ne_LHA             ' P.Ne_LHA               'nM    '    'Basal Norepinephrine levels in LHA                  '
        'fLHA               ' P.fLHA                 'Hz    '    'Basal firing rate of orexin neurons in LHA          '
        'FiveHT_Vmax_DRN_LHA' P.FiveHT_Vmax_DRN_LHA  'nM/Sec'    'Per-stimulus 5-HT release in LHA                    '
        'FiveHT_Km_DRN_LHA  ' P.FiveHT_Km_DRN_LHA    'nM    '    'Per-stimulus 5-HT release in LHA                    '
        'FiveHTp_DRN_LHA    ' P.FiveHTp_DRN_LHA      'nM    '    'Per-stimulus 5-HT release in LHA                    '
        'FiveHT_Vmax_DRN_LC ' P.FiveHT_Vmax_DRN_LC   'nM/Sec'    'Per-stimulus 5-HT release in LC                     '
        'FiveHT_Km_DRN_LC   ' P.FiveHT_Km_DRN_LC     'nM    '    'Per-stimulus 5-HT release in LC                     '
        'FiveHTp_DRN_LC     ' P.FiveHTp_DRN_LC       'nM    '    'Per-stimulus 5-HT release in LC                     '
        'Ne_Vmax_LC_LHA     ' P.Ne_Vmax_LC_LHA       'nM/Sec'    'Per-stimulus Ne release in LHA                      '
        'Ne_Km_LC_LHA       ' P.Ne_Km_LC_LHA         'nM    '    'Per-stimulus Ne release in LHA                      '
        'Nep_LC_LHA         ' P.Nep_LC_LHA           'nM    '    'Per-stimulus Ne release in LHA                      '
        'Ne_Vmax_LC_DRN     ' P.Ne_Vmax_LC_DRN       'nM/Sec'    'Per-stimulus Ne release in DRN                      '
        'Ne_Km_LC_DRN       ' P.Ne_Km_LC_DRN         'nM    '    'Per-stimulus Ne release in DRN                      '
        'Nep_LC_DRN         ' P.Nep_LC_DRN           'nM    '    'Per-stimulus Ne release in DRN                      '
        'tauOx_DRN          ' P.tauOx_DRN            'Sec   '    'Timescale of Ox on DRN neurons                      '
        'tauNe_DRN          ' P.tauNe_DRN            'Sec   '    'Timescale of Ne on DRN neurons                      '
        'tauOx_LC           ' P.tauOx_LC             'Sec   '    'Timescale of Ox on LC neurons                       '
        'tau5HT_LC          ' P.tau5HT_LC            'Sec   '    'Timescale of 5-HT on LC neurons                     '
        'tau5HT_LHA         ' P.tau5HT_LHA           'Sec   '    'Timescale of 5-HT on LHA neurons                    '
        'tauNe_LHA          ' P.tauNe_LHA            'Sec   '    'Timescale of Ne on LHA neurons                      '
        'mul                ' P.mul                  '      '    'Multiplicative factor for Ox-A/B rise-factor        '
        'Rise_Ox_A_DRN      ' P.Rise_Ox_A_DRN        '1/Sec '    'Ox-A release in DRN: Rise factor for orexin release '
        'Decay_Ox_A_DRN     ' P.Decay_Ox_A_DRN       '1/Sec '    'Ox-A release in DRN: Decay Rate for orexin release  '
        'Rise_Ox_B_DRN      ' P.Rise_Ox_B_DRN        '1/Sec '    'Ox-B release in DRN: Rise factor for orexin release '
        'Decay_Ox_B_DRN     ' P.Decay_Ox_B_DRN       '1/Sec '    'Ox-B release in DRN: Decay Rate for orexin release  '
        'Rise_Ox_A_LC       ' P.Rise_Ox_A_LC         '1/Sec '    'Ox release in LC: Rise factor for orexin release    '
        'Decay_Ox_A_LC      ' P.Decay_Ox_A_LC        '1/Sec '    'Ox release in LC: Decay Rate for orexin release     '
        'I0_LHA             ' P.I0_LHA               'pA    '    'Initial current in LHA                              '
        'I0_DRN             ' P.I0_DRN               'pA    '    'Initial current in DRN                              '
        'I0_LC              ' P.I0_LC                'pA    '    'Initial current in LC                               '
        'Ibackground_LHA    ' P.Ibackground_LHA      'pA    '    'Background current in LHA                           '
        'Ibackground_DRN    ' P.Ibackground_DRN      'pA    '    'Background current in DRN                           '
        'Ibackground_LC     ' P.Ibackground_LC       'pA    '    'Background current in LC                            '};
    
    Tab = uitable(...
        'Position', [50 120 580 730], 'ColumnWidth', {120 100 40 300},...
        'Data',Param,...
        'ColumnEditable', [false true false false]);
    
    
    set(Tab, 'columnname', {'Param', 'Value','Unit','Description'});
    
elseif strcmp(action,'info');
    helpwin(mfilename);
    
elseif strcmp(action,'Default');
    priors
    
    
%     Param = {
%         'OxRelease_A_DRN    ' P.OxRelease_A_DRN      'NM    '    'Basal Orexin levels in DRN                          '
%         'OxRelease_B_DRN    ' P.OxRelease_B_DRN      'NM    '    'Basal Orexin levels in DRN                          '
%         'Ne_DRN             ' P.Ne_DRN               'NM    '    'Basal Norepinephrine levels in DRN                  '
%         'fDRN               ' P.fDRN                 'Hz    '    'Basal firing rate of DRN neurons                    '
%         'OxRelease_A_LC     ' P.OxRelease_A_LC       'NM    '    'Basal Orexin levels in LC                           '
%         'FiveHT_LC          ' P.FiveHT_LC            'NM    '    'Basal Serotonin (5-HT) levels in LC                 '
%         'fLC                ' P.fLC                  'Hz    '    'Basal firing rate of orexin neurons in LC           '
%         'FiveHT_LHA         ' P.FiveHT_LHA           'nM    '    'Basal Serotonin (5-HT)levels in LC                  '
%         'Ne_LHA             ' P.Ne_LHA               'nM    '    'Basal Norepinephrine levels in LHA                  '
%         'fLHA               ' P.fLHA                 'Hz    '    'Basal firing rate of orexin neurons in LHA          '
%         'FiveHT_Vmax_DRN_LHA' P.FiveHT_Vmax_DRN_LHA  'nM/Sec'    'Per-stimulus 5-HT release in LHA                    '
%         'FiveHT_Km_DRN_LHA  ' P.FiveHT_Km_DRN_LHA    'nM    '    'Per-stimulus 5-HT release in LHA                    '
%         'FiveHTp_DRN_LHA    ' P.FiveHTp_DRN_LHA      'nM    '    'Per-stimulus 5-HT release in LHA                    '
%         'FiveHT_Vmax_DRN_LC ' P.FiveHT_Vmax_DRN_LC   'nM/Sec'    'Per-stimulus 5-HT release in LC                     '
%         'FiveHT_Km_DRN_LC   ' P.FiveHT_Km_DRN_LC     'nM    '    'Per-stimulus 5-HT release in LC                     '
%         'FiveHTp_DRN_LC     ' P.FiveHTp_DRN_LC       'nM    '    'Per-stimulus 5-HT release in LC                     '
%         'Ne_Vmax_LC_LHA     ' P.Ne_Vmax_LC_LHA       'nM/Sec'    'Per-stimulus Ne release in LHA                      '
%         'Ne_Km_LC_LHA       ' P.Ne_Km_LC_LHA         'nM    '    'Per-stimulus Ne release in LHA                      '
%         'Nep_LC_LHA         ' P.Nep_LC_LHA           'nM    '    'Per-stimulus Ne release in LHA                      '
%         'Ne_Vmax_LC_DRN     ' P.Ne_Vmax_LC_DRN       'nM/Sec'    'Per-stimulus Ne release in DRN                      '
%         'Ne_Km_LC_DRN       ' P.Ne_Km_LC_DRN         'nM    '    'Per-stimulus Ne release in DRN                      '
%         'Nep_LC_DRN         ' P.Nep_LC_DRN           'nM    '    'Per-stimulus Ne release in DRN                      '
%         'tauOx_DRN          ' P.tauOx_DRN            'Sec   '    'Timescale of Ox on DRN neurons                      '
%         'tauNe_DRN          ' P.tauNe_DRN            'Sec   '    'Timescale of Ne on DRN neurons                      '
%         'tauOx_LC           ' P.tauOx_LC             'Sec   '    'Timescale of Ox on LC neurons                       '
%         'tau5HT_LC          ' P.tau5HT_LC            'Sec   '    'Timescale of 5-HT on LC neurons                     '
%         'tau5HT_LHA         ' P.tau5HT_LHA           'Sec   '    'Timescale of 5-HT on LHA neurons                    '
%         'tauNe_LHA          ' P.tauNe_LHA            'Sec   '    'Timescale of Ne on LHA neurons                      '
%         'mul                ' P.mul                  '      '    'Multiplicative factor for Ox-A/B rise-factor        '
%         'Rise_Ox_A_DRN      ' P.Rise_Ox_A_DRN        '1/Sec '    'Ox-A release in DRN: Rise factor for orexin release '
%         'Decay_Ox_A_DRN     ' P.Decay_Ox_A_DRN       '1/Sec '    'Ox-A release in DRN: Decay Rate for orexin release  '
%         'Rise_Ox_B_DRN      ' P.Rise_Ox_B_DRN        '1/Sec '    'Ox-B release in DRN: Rise factor for orexin release '
%         'Decay_Ox_B_DRN     ' P.Decay_Ox_B_DRN       '1/Sec '    'Ox-B release in DRN: Decay Rate for orexin release  '
%         'Rise_Ox_A_LC       ' P.Rise_Ox_A_LC         '1/Sec '    'Ox release in LC: Rise factor for orexin release    '
%         'Decay_Ox_A_LC      ' P.Decay_Ox_A_LC        '1/Sec '    'Ox release in LC: Decay Rate for orexin release     '
%         'I0_LHA             ' P.I0_LHA               'pA    '    'Initial current in LHA                              '
%         'I0_DRN             ' P.I0_DRN               'pA    '    'Initial current in DRN                              '
%         'I0_LC              ' P.I0_LC                'pA    '    'Initial current in LC                               '
%         'Ibackground_LHA    ' P.Ibackground_LHA      'pA    '    'Background current in LHA                           '
%         'Ibackground_DRN    ' P.Ibackground_DRN      'pA    '    'Background current in DRN                           '
%         'Ibackground_LC     ' P.Ibackground_LC       'pA    '    'Background current in LC                            '};
%     
    
    Tab = uitable(...
        'Position', [50 65 580 730], 'ColumnWidth', {120 80 40 300},...
        'Data',Param,...
        'ColumnEditable', [false true false false]);
    
    
    set(Tab, 'columnname', {'Param', 'Value','Unit','Description'});
    
    T  =  str2double(get(Edt1,'string'));
    t  =  0:dt:T;  % Simulation time 1000 sec
    y  =  model();
    disp('Simulation is finished,');
    disp('Please press outputs to see the results.');
    
elseif strcmp(action,'Simulate');
    
    data_Tab = get(Tab,'Data');
    
    P.OxRelease_A_DRN      = cell2mat(data_Tab(1,2));
    P.OxRelease_B_DRN      = cell2mat(data_Tab(2,2));
    P.Ne_DRN               = cell2mat(data_Tab(3,2));
    P.fDRN                 = cell2mat(data_Tab(4,2));
    P.OxRelease_A_LC       = cell2mat(data_Tab(5,2));
    P.FiveHT_LC            = cell2mat(data_Tab(6,2));
    P.fLC                  = cell2mat(data_Tab(7,2));
    P.FiveHT_LHA           = cell2mat(data_Tab(8,2));
    P.Ne_LHA               = cell2mat(data_Tab(9,2));
    P.fLHA                 = cell2mat(data_Tab(10,2));
    
    P.FiveHT_Vmax_DRN_LHA  = cell2mat(data_Tab(11,2));
    P.FiveHT_Km_DRN_LHA    = cell2mat(data_Tab(12,2));
    P.FiveHTp_DRN_LHA      = cell2mat(data_Tab(13,2));
    P.FiveHT_Vmax_DRN_LC   = cell2mat(data_Tab(14,2));
    P.FiveHT_Km_DRN_LC     = cell2mat(data_Tab(15,2));
    P.FiveHTp_DRN_LC       = cell2mat(data_Tab(16,2));
    P.Ne_Vmax_LC_LHA       = cell2mat(data_Tab(17,2));
    P.Ne_Km_LC_LHA         = cell2mat(data_Tab(18,2));
    P.Nep_LC_LHA           = cell2mat(data_Tab(19,2));
    P.Ne_Vmax_LC_DRN       = cell2mat(data_Tab(20,2));
    P.Ne_Km_LC_DRN         = cell2mat(data_Tab(21,2));
    
    P.Nep_LC_DRN           = cell2mat(data_Tab(22,2));
    P.tauOx_DRN            = cell2mat(data_Tab(23,2));
    P.tauNe_DRN            = cell2mat(data_Tab(24,2));
    P.tauOx_LC             = cell2mat(data_Tab(25,2));
    P.tau5HT_LC            = cell2mat(data_Tab(26,2));
    P.tau5HT_LHA           = cell2mat(data_Tab(27,2));
    P.tauNe_LHA            = cell2mat(data_Tab(28,2));
    P.mul                  = cell2mat(data_Tab(29,2));
    P.Rise_Ox_A_DRN        = cell2mat(data_Tab(30,2));
    P.Decay_Ox_A_DRN       = cell2mat(data_Tab(31,2));
    P.Rise_Ox_B_DRN        = cell2mat(data_Tab(32,2));
    P.Decay_Ox_B_DRN       = cell2mat(data_Tab(33,2));
    P.Rise_Ox_A_LC         = cell2mat(data_Tab(34,2));
    P.Decay_Ox_A_LC        = cell2mat(data_Tab(35,2));
    P.I0_LHA               = cell2mat(data_Tab(36,2));
    P.I0_DRN               = cell2mat(data_Tab(37,2));
    P.I0_LC                = cell2mat(data_Tab(38,2));
    P.Ibackground_LHA      = cell2mat(data_Tab(39,2));
    P.Ibackground_DRN      = cell2mat(data_Tab(40,2));
    P.Ibackground_LC       = cell2mat(data_Tab(41,2));
    
    T  = str2double(get(Edt1,'string'));
    t  = 0:dt:T;  % Simulation time 1000 sec
    y  = model();
    
    Receptor_Density(y);
    
    disp('Simulation is finished,');
    disp('Please press outputs to see the results.');
end
    function y = model()
        
        % Updating time
        T =  str2double(get(Edt1,'string'));
        t  = 0:dt:T;  % Simulation time 1000 sec
        
        % Prior settings
        [y,eta,Alpha,yp,Vm,Km,P1,P2,P3,P4,Ta,Ki,I0,Ib] = par_setting(P);
        
        for i = 2:length(t)
            
            y(i,:) = y(i-1,:)+ dt.*m_equation(y(i-1,:),eta,Alpha,yp,Vm,Km,P1,P2,P3,P4,Ta);
            
            % Firing rate of LHA neurons based on the incoming currents
            I_tot = -y(i,8) -y(i,9);
            y(i,10) =((Ki(10)*(I_tot-I0(10)+Ib(10)))*(Ki(10)*(I_tot-I0(10)+Ib(10))>=0));
            
            % Firing rate of DRN neurons based on the incoming currents
            I_tot = y(i,11)+ y(i,12)+ y(i,13);
            y(i,14) = ((Ki(14)*(I_tot-I0(14)+Ib(14)))*(Ki(14)*(I_tot-I0(14)+Ib(14))>=0));
            
            % Firing rate of LC neurons based on the incoming currents
            I_tot = y(i,15)- y(i,16);
            y(i,17) = ((Ki(17)*(I_tot-I0(17)+Ib(17)))*(Ki(17)*(I_tot-I0(17)+Ib(17))>=0));
            
        end
    end
    function Receptor_Density(y)
        
        figure(fig1);
        cla ;
        isosurface(data.foo,A);
        colormap(gray);
        freezeColors %freeze this plot's colormap       
        axis on
        axis vis3d;
        grid on; axis equal;
        hold on;
        alpha(0.2);
        rotate3d on;
        set(gca,'XTickLabel',linspace(-100,100,5));
        set(gca,'YTickLabel',linspace(-100,100,5));
        set(gca,'ZTickLabel',linspace(-100,100,5));
        xlabel('X');
        ylabel('Y');
        zlabel('Z');
        
        view([-170,24]);
        
        P1 = [28,31,26];
        text(P1(1),P1(2),P1(3),'    LHA','HorizontalAlignment','left','FontSize',8);
        
        P2 = [26,34,20];
        text(P2(1),P2(2),P2(3),'    LC','HorizontalAlignment','left','FontSize',8);
        
        P3 = [29,33,23];
        text(P3(1),P3(2),P3(3),'DRN   ','HorizontalAlignment','right','FontSize',8);
        
        pt1 = [P1; P2];
        plot3(pt1(:,1), pt1(:,2), pt1(:,3))
%         arrow3([pt1(1,1),pt1(1,2),pt1(1,3)],[pt1(2,1),pt1(2,2),pt1(2,3)],'b',1,1);
%         arrow3([pt1(2,1),pt1(2,2),pt1(2,3)],[pt1(1,1),pt1(1,2),pt1(1,3)],'b',1,1);
        
        pt2 = [P1; P3];
        plot3(pt2(:,1), pt2(:,2), pt2(:,3))
        
        pt3 = [P2; P3];
        plot3(pt3(:,1), pt3(:,2), pt3(:,3))
        
        rotate3d on;
        
        Theta       = linspace(0,2*pi,200);
        Phi         = linspace(0,2*pi,200);
        [theta,phi] = meshgrid(Theta,Phi);
        rho1        = sin(phi);
        [x1,y1,z1]  = sph2cart(theta,phi,2*rho1);
        
        colorimg1 = color_coding (y(:,10));
        colorimg2 = color_coding (y(:,17));
        colorimg3 = color_coding (y(:,14));
        
        Sim_scale =  str2double(get(Edt2,'string'));
        
        for i = round(linspace(1,length(t),Sim_scale))
            hold on
            surf(x1+P1(1),y1+P1(2),z1+P1(3),'FaceColor',colorimg1(i,:),'EdgeColor','none'); caxis([0, 1]);
            surf(x1+P2(1),y1+P2(2),z1+P2(3),'FaceColor',colorimg2(i,:),'EdgeColor','none');
            surf(x1+P3(1),y1+P3(2),z1+P3(3),'FaceColor',colorimg3(i,:),'EdgeColor','none');
            title(sprintf('Time = %g s',t(i)));
            pause(0.5)
            colormap(jet);
            
        end
    end

    function [y,eta,Alpha,yp,Vm,Km,P1,P2,P3,P4,Ta,Ki,I0,Ib] = par_setting(P)
        
        eta(1) = P.Decay_Ox_A_DRN;
        eta(2) = P.Decay_Ox_B_DRN;
        eta(3) = 0;
        eta(4) = P.Decay_Ox_A_LC;
        
        
        Alpha(1) = P.Rise_Ox_A_DRN;
        Alpha(2) = P.Rise_Ox_B_DRN;
        Alpha(3) = 0;
        Alpha(4) = P.Rise_Ox_A_LC;
        
        % yp
        yp    = zeros(7,1);
        yp(3) = P.Nep_LC_DRN;
        yp(5) = P.FiveHTp_DRN_LC;
        yp(6) = P.FiveHTp_DRN_LHA;
        yp(7) = P.Nep_LC_LHA;
        
        
        % Vmax
        Vm    = zeros(7,1);
        Vm(3) = P.Ne_Vmax_LC_DRN;
        Vm(5) = P.FiveHT_Vmax_DRN_LHA;
        Vm(6) = P.FiveHT_Vmax_DRN_LHA;
        Vm(7) = P.Ne_Vmax_LC_LHA;
        
        
        % Km
        Km     = zeros(7,1);
        Km (3) = P.Ne_Km_LC_DRN;
        Km (5) = P.FiveHT_Km_DRN_LC;
        Km (6) = P.FiveHT_Km_DRN_LHA;
        Km (7) = P.Ne_Km_LC_LHA;
        
        % P1
        P1     = zeros(16,1);
        P1(15) = 3.8;
        
        % P2
        P2      = zeros(16,1);
        P2(8)   = 36;
        P2(9)   = 120;
        P2(11)  = 65;
        P2(12)  = 65;
        P2(13)  = 57;
        P2(15)  = 54;
        P2(16)  = 40;
        
        % P3
        P3      = zeros(16,1);
        P3(8)   = -1.55;
        P3(9)   = -5.39;
        P3(11)  = -2.08;
        P3(12)  = -2.08;
        P3(13)  = -3.7;
        P3(15)  = -2.3;
        P3(16)  = 4.2;
        
        % P4
        P4      = zeros(16,1);
        P4(8)   = 0.4;
        P4(9)   = 0.4;
        P4(11)  = 0.452;
        P4(12)  = 0.452;
        P4(13)  = 0.193;
        P4(15)  = 0.341;
        P4(16)  = 0.347;
        
        % T = 1/Tau
        Ta      = zeros(16,1);
        Ta(8)   = 1/P.tau5HT_LHA;
        Ta(9)   = 1/P.tauNe_LHA;
        Ta(11)  = 1/P.tauOx_DRN;
        Ta(12)  = 1/P.tauOx_DRN;
        Ta(13)  = 1/P.tauNe_DRN;
        Ta(15)  = 1/P.tauOx_LC;
        Ta(16)  = 1/P.tau5HT_LC;
        
        % Ki
        Ki      = zeros(16,1);
        Ki(10)  = 0.20;
        Ki(14)  = 0.033;
        Ki(17)  = 0.058;
        
        % I0
        I0        = zeros(16,1);
        I0(10)    = P.I0_LHA;
        I0(14)    = P.I0_DRN;
        I0(17)    = P.I0_LC;
        
        % Ibias
        Ib        = zeros(16,1);
        Ib(10)    = P.Ibackground_LHA;
        Ib(14)    = P.Ibackground_DRN;
        Ib(17)    = P.Ibackground_LC;
        
        % output
        y     = zeros(1,17);
        y(1)  = P.OxRelease_A_DRN;
        y(2)  = P.OxRelease_B_DRN;
        y(3)  = P.Ne_DRN;
        y(4)  = P.OxRelease_A_LC;
        y(5)  = P.FiveHT_LC;
        y(6)  = P.FiveHT_LHA;
        y(7)  = P.Ne_LHA;
        
        y(10) = P.fLHA;
        y(14) = P.fDRN;
        y(17) = P.fLC;
    end
    function [colorimg] = color_coding (planeimg)
        % scale the between [0, 255] in order to use a custom color map for it.
        minplaneimg = min(min(planeimg)); % find minimum first.
        scaledimg = (floor(((planeimg - minplaneimg) ./ ...
            (max(max(planeimg)) - minplaneimg)) * 255)); % perform scaling
        % convert the image to a true color image with the jet colormap.
        colorimg = squeeze(ind2rgb(scaledimg,jet(256)));
    end

end