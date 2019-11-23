clear
load('/data3/LiZhiai/beijing_fmri/CCG_SPM/MVPA/weight_map/pexp3.mat'); %/data3/LiZhiai/beijing_fmri/CCG_SPM/MVPA/weight_map/pexp3.mat
load('/data3/LiZhiai/beijing_fmri/CCG_SPM/MVPA/weight_map/pexp4.mat');
f1 = pexp3; %[32609.9250744236 41358.5171181296 96210.6326713763 38596.0427028299 27411.2719650086 71004.9392834364 52577.9569687703 -1974.60252388206 -40802.2243390967 11019.0180894994 18800.2554463930 46315.1619812122 57055.7666706705 82776.5766271219 50356.8863870966 28960.3280255232 -29454.9884834338 64008.5268027506 34592.9484059005 21105.3876799869 23923.6453420719 -22689.0209316438 88623.6672222717 83938.1555825311 9517.82776972795 118384.339972978 71005.9667655822 -3313.34673870313 -6454.10914066270 15234.2958422179 52804.5454624267]';
f2 = pexp4; %[60996.1645742676 47345.3877949342 -30575.3773597259 35629.0774750160 40922.1411770739 53654.5093731142 -4122.40706098538 -30696.0451798721 -3211.33236002057 43915.6459946130 34405.1623959428 -4485.42928290914 43621.2931052852 35120.9630093335 31123.5457056304 35856.8059625322 -26904.1731458519 59127.6795398287 5024.53277668864 13251.7251258238 11211.2553680237 -34261.9044307675 59326.6031252605 32381.2199340362 -15046.8187877134 92993.3313204160 96306.0195286200 44266.2538765740 31876.8153658846 15689.8535527518 31952.2283948197]';
% c = []';[0.446950748856806,0.443548463680480,-0.373795483894740,-0.974258495118210,0.111712744699063;]
% d = []';
nsub = length(f1);
label = [ones(nsub,1);-1*ones(nsub,1)];
to_be_test = [f1;f2];

create_figure('ROC'); ROC1 = roc_plot(to_be_test, label > 0, 'color', [1,0.5,0], 'threshold', 0, 'twochoice'); %forced based on other's pattern, get ROC











