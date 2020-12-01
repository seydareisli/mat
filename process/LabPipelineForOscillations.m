%{
Analyses	of	frequency	and	phase	were	performed	on	epochs	that	were	lowpass	 filtered	 at	 55Hz,	 and	 high	 pass	 filtered	 at	 0.1H
To	 visualize	 entrainment	 of	 oscillatory	activity	to	the	rhythm	of	visual	events	(1.5	Hz),	data	were	low-passed	filtered	at	
1.9	 Hz.	 For	 this,	 a	 Finite	 Impulse	 Response	 (FIR)	 filter,	 with	 normalized passband	
frequency	of	 1.9	Hz,	 stopband	 frequency	of	 4	Hz,	passband	Ripple	of	 1Hz	and stopband	
attenuation	of	60	dB, was	applied.
In	 the	 entrainment	 analysis	 pipeline	 (pipeline	 2	 above),	 Inter-trial	 Phase	 Coherence	
(ITPC)	 was	 calculated	 separately	 for	 each	 individual	 participant,	 between	 all	 trials	 in	 the	 two	
experimental	 cond
itions	 (cued	and	 non-cued).	This	measure	 quantifies	 the	 consistency	 of	the	
phase of responses	across	trials
	ITPC	was	calculated	as	the	circular	variance	of	the	phase	across	trials (Luo	&	 Poeppel,	 2007) at	each	 frequency	 and	 time	 bin,	 and	 averaged	 across	 time	bins.	
Coherence	was	calculated	as	following:
(sum of cos teta at nij over N)^2 +(sum of sin teta at nij over N)^2
where teta os the phase at freuqency bin i and temporal bin j. 
Phase	Coherence	was	calculated	 for	the	range	of	0.6-2.7	Hz.	A	larger	
ITPC	 index	 corresponds	 to	 stronger	 coherence
ITPC	was	first	calculated	for	the	frequency	domain,	collapsed	across	the	3500ms.	time	window	
(including	the	four	visual	cues	and	auditory	target)	at	all	scalp	electrodes.	
The	frequency	range	 0.6–2.7	Hz was	divided	into	28	bins. To	evaluate	differences	in	ITPC	between	the	groups,

To	evaluate	differences	in	ITPC	between	the	groups, a 2- way	ANOVA was	performed	on	the	ITPC	values	with	Group	and	Cue	as	 factors.	
In	addition,	to	 evaluate	the	time	course	of	the	ITPC,	we	calculated	ITPC	for	each	time	and	frequency	bin	in	the	 range	 of	 the	 whole	 trial	 (2900ms),	 and	 at	 2-7	 Hz,	 respectively.	 
For	 this,	 we	 used	 wavelets	 ranging	from	2	to	7	Hz	with	1	Hz	width,	and	divided	the	time	window	of	400 to	2400ms post	the	 first	 cue	 onset,	 in	 steps	 of	 4ms.	 
The	 edges	 of	 the	 time	 domain	 were	 trimmed	 due	 to	 requirements	 of	 wavelet	 time-frequency	 decomposition.
The	 large	 frequency	 range	 was	 included	 in	 order	 to explore	 effects	 in	 higher	 frequencies	 than	 that	 of	 stimulation.	 
For	 visualization,	 differences	 in	ITPC	 between TD	 and	 ASD	 groups	 were	 calculated	 by	 subtracting	 ITPC	 values of ASD	 group	 averages from	 those	 of	 TD	 group	 averages,	 for each	 time	 and	 frequency point.	
Nonparametric	 statistics	 were	 computed	 using	 permutation	 tests.	 
To	 assess	 the	null	distribution,	the	group	labels	were	randomly	intermixed	for	each	subject,	and	the	ITPC	 difference	was	computed	with	p<0.05	as	a	threshold.	
This	procedure	repeated	10000	times	for	 ITPC	across,	on	each	frequency	and	time point	in	the	6*501	matrix (Zoefel et	al.,	2017).	









