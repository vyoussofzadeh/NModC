%------- Initializing the other variables and functions -----------------
% global eta Alpha Vm Km P1 P2 P3 P4 Ta Ki I0 Ib

P.OxRelease_A_DRN(1) = 3.4;  % Basal Orexin levels in DRN, assumed to be same as Ox-B release, in nM(Feng et al., 2008)
P.OxRelease_B_DRN(1) = 3.4;  % Basal Orexin levels in DRN, estimated from midbrain area, in nM
P.Ne_DRN(1)          = 2950; % Basal Norepinephrine levels in DRN, in nM (Gutknecht et al., 2012)
P.fDRN(1)            = 0.8;  % Basal firing rate of DRN neurons, in units Hz (Kirby et a., 2003)

P.OxRelease_A_LC(1)  = 0.56; % Basal Orexin levels in LC,estimated from pons area, in nM (Feng et al.,2008) 
P.FiveHT_LC(1)       = 0.00000011; % Basal Serotonin (5-HT)levels in LC,in nM (Singewald et al., 1998)
P.fLC(1)             = 2.15; % ~Basal firing rate of orexin neurons in LC, in units of Hz (Jedema and Grace 2003) 

P.FiveHT_LHA(1)      = 1.6;  % Basal Serotonin (5-HT)levels in LC, in nM (Lorrain et al., 1997)
P.Ne_LHA             = 0.83; % Basal Norepinephrine levels in LHA, in nM (Swanson, C.J et al., 2006)
P.fLHA(1)            = 2.3;  % ~Basal firing rate of orexin neurons in LHA, in units of Hz (Yamanaka et al., 2010) 

%-------- Parameters for 5-HT release in LHA modified from Bunin et al.1998 -------------------------
P.FiveHT_Vmax_DRN_LHA = 1800;  % In units of nM/sec
P.FiveHT_Km_DRN_LHA   = 170;   % In units of nM 170
P.FiveHTp_DRN_LHA     = 12.14; % In units of nM

%-------- Parameters for 5-HT release in LC modified from Bunin et al.1998 -------------------------
P.FiveHT_Vmax_DRN_LC = 1800;        % In units of nM/sec
P.FiveHT_Km_DRN_LC   = 170;         % In units of nM 170
P.FiveHTp_DRN_LC     = 0.000000852; % In units of nM

%-------- Parameters for Ne release in LHA modified from (Mitchell,Oke and Adams, 1994)  -------------------------
% Under the assumption that Ne release at DLG and LC are same
P.Ne_Vmax_LC_LHA = 74;     % In units of nM/sec
P.Ne_Km_LC_LHA   = 400;    % In units of nM
P.Nep_LC_LHA     = 0.0642; % In units of nM

%-------- Parameters for Ne release in DRN modified from (Mitchell,Oke and Adams, 1994)-------------------------
% Under the assumption that Ne release at DLG and LC are same
P.Ne_Vmax_LC_DRN = 74;     % In units of nM/sec
P.Ne_Km_LC_DRN   = 400;    % In units of nM
P.Nep_LC_DRN     = 27.272; % In units of nM 

%-------- paramater values related to the time constant of the effect of 5-HT,Ne and Ox on the LHA, DRN,LC neurons ------
P.tauOx_DRN  = 60; % Timescale of Ox on DRN neurons, in units of sec (Soffin et al. 2004)
P.tauNe_DRN  = 20; % Timescale of Ne on DRN neurons, in units of sec (Couch J.R., Jr 1970)
P.tauOx_LC   = 20; % Timescale of Ox on LC neurons, in units of sec (Hagan et al., 1999)
P.tau5HT_LC  = 20; % Timescale of 5-HT on LC neurons, in units of sec (Haddjeri, Montigny and Blier 1997)
P.tau5HT_LHA = 2;  % Timescale of 5-HT on LHA neurons, in units of sec (Muraki et al., 2004)
P.tauNe_LHA  = 1;  % Timescale of Ne on LHA neurons, in units of sec ( Li and Van den Pol, 2005)

% Multiplicative factor for Ox-A/B rise-factor
P.mul = 1;

% Ox-A release in DRN
%----- Parameters estimated from basal steady-states of all variables--
P.Rise_Ox_A_DRN  = P.mul.*1.405; % Rise factor for orexin release
P.Decay_Ox_A_DRN = 0.85;       % Decay Rate for orexin release %0.85

% Ox-B release in DRN
%----- Parameters estimated from basal steady-states of all variables--
P.Rise_Ox_B_DRN  = P.mul.*1.405; % Rise factor for orexin release 
P.Decay_Ox_B_DRN = 0.85;       % Decay Rate for orexin release 0.85

% Ox release in LC
%----- Parameters estimated from basal steady-states of all variables--
P.Rise_Ox_A_LC  = P.mul.*0.2314; % Rise factor for orexin release 
P.Decay_Ox_A_LC = 0.85;        % Decay Rate for orexin release 0.85


P.I0_LHA = 0;
P.I0_DRN = 0.13;
P.I0_LC  = 0.028;
P.Ibackground_LHA = 11.5;
P.Ibackground_DRN = 24.82;
P.Ibackground_LC  = 37.41;


