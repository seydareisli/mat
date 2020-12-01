function text = writeStatResults(testType, table, factorNames)

%convert all values in the table/result to a character array? 
p = digit 2 

% ANOVA To write: 
if size(tbl) ~= [6 7]; fprintf('Hey Seyda, you should check the table!\n'); continue; end
for i=2:4
if num2str(tbl{i,7}) <alpha; preText=' showed significant effect '; else; preText=' showed no significant effect '; end
txt = [ num2str(tbl{i,1}),preText,'[F(',num2str(tbl{i,3}), ',' , num2str(tbl{6,3}),') = ',num2str(tbl{i,6}),', p = ', num2str(num2str(tbl{i,7})),']']
end

% T-Test To write: '(R2 = 0.45, p = 0.1) for Neurotypical group'
pvaltext='0.1';
r2text='0.45';
grp={'Neurotypical', 'Autism'};
i=1;
['(R2 = ', r2text,', p = ', pvaltext, ') for ', grp{i}, ' group']

%running dependent samples t-tests were performed between summed and multisensory conditions (for aligned and misaligned conditions) 
%across all channels and time points
%The rationale for this method is that Type I errors are unlikely to endure for several consecutive time points.
%This approach gives an assessment of significant effects of response type across the entire epoch and displays the p-values as a two-dimensional statistical color-scaled map [see Statistical Cluster Plots (SCPs)].


%{
Two papers tried a table of windows:

1) Nonparametric Statistical Analysis of Map Topographies on the Epoch Level
https://link.springer.com/referenceworkentry/10.1007%2F978-3-319-62657-4_13-1

2) Selective Attention Modulates Face-Specific Induced Gamma Oscillations Recorded from Ventral Occipitotemporal Cortex
https://www.jneurosci.org/content/30/26/8780/tab-figures-data

Epoch	t value (df)	p value
Event-related potential		
    1: 0–75 ms      0.63 (21)	0.536
    2: 75–150 ms	0.87 (21)	0.398
    3: 150–225 ms	−0.96 (21)	0.350
    4: 225–300 ms	−3.08 (21)	0.006
    5: 300–375 ms	−3.83 (21)	0.001
    6: 375–450 ms	−2.32 (21)	0.031
    7: 450–525 ms	−3.21 (21)	0.006
    8: 525–600 ms	−3.00 (21)	0.007
    9: 600–675 ms	−2.59 (21)	0.017
    10: 675–750 ms	−2.80 (21)	0.011
    
For statistical analysis, SPSS 15.0 (SPSS, Chicago, IL) software was used. Behavioral performance (reaction time,
accuracy) data were analyzed by two-way analysis of
variance (ANOVA) for repeated measures with factors auditory condition (two levels: standard vs. deviant tone)
and Stroop condition (two levels: congruent vs. incongruent). ERPs were analyzed in different steps. Based on
the finding that negativities were maximal at central electrodes, statistical analyses were restricted to the central
derivation line. In order to test the hypothesis that nonmatching auditory prestimuli would change the latency
and/or amplitude of the negativity after incongruent
Stroop stimuli, we segmented the relevant time period
between 150 and 600 msec after the Stroop stimulus into
six time segments (150–225, 225–300, 300–375, 375–450,
450–525, 525–600 msec). In a first step, a four-way ANOVA
for repeated measures on all factors was conducted
with the factors time segment (6 levels: see above),
Stroop condition (2 levels: congruent vs. incongruent),
auditory condition (2 levels: standard vs. deviant), and
anterior–posterior electrode position (5 levels: Fz, FCz,
Cz, CPz, Pz). Based on the finding that the anterior–
posterior position exhibited an ordinal influence in the
significant four-way interaction term ( p < .0001), data of
the anterior–posterior locations were pooled and further
analyzed by a three-way ANOVA for repeated measures.
All p values derived from ANOVAs were based on Greenhouse–Geisser corrected degrees of freedom, but the
original degrees of freedom are reported. In case of a
significant main or interaction effect, subsequent post
hoc analyses were performed by means of linear contrasts
with alpha correction for multiple comparisons (CurranEverett, 2000). The threshold for alpha errors was set at
p < .05. Means ± SEM values are presented.


%}


%{
Writing about the SCP method that I applied :

ANOVA  was performed at each time Point (122 time points X 160 channels = 19520 tests). 
To control for type 2 errors, we applied a further level of analyses. We counted a test that was sound to be significant only if testi at consecutive time points and  neighbouring channels also show significance. 
Specifically, we looked at one time point before and arter, and 8 surrounding channels having the same diameter distance to our channel (8x3=24 values) and make sure that at least half of these values are significant before actually accepting the significance. 


if p(3)<0.05;
text=[' Two way ANOVA at channel ',chanlocs(19).labels, ' showed a significant group-condition interaction (p=',num2str(p(3)),').']
end

%}




%{
there was a stronginteraction between



https://drive.google.com/drive/search?q=%22600%20ms%22%20parent:1cmSWi7xBrQhwvhyIRVirjtjz_j2S-udc


intro="https://drive.google.com/drive/search?q=";
parent="%20parent:1cmSWi7xBrQhwvhyIRVirjtjz_j2S-udc";
search = "two%20way%20anova";
link=[ intro search parent]

quote= %22
space =%20


