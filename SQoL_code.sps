* Encoding: UTF-8.

DATASET ACTIVATE Dataset1.

*RECODING VARIABLES.
*LIHS: high score = high homobinegativity.
RECODE LIHS_1 (1=7) (2=6) (3=5) (4=4) (5=3) (6=2) (7=1).
RECODE LIHS_2 (1=7) (2=6) (3=5) (4=4) (5=3) (6=2) (7=1).
RECODE LIHS_3 (1=7) (2=6) (3=5) (4=4) (5=3) (6=2) (7=1).
RECODE LIHS_5 (1=7) (2=6) (3=5) (4=4) (5=3) (6=2) (7=1).
RECODE LIHS_6 (1=7) (2=6) (3=5) (4=4) (5=3) (6=2) (7=1).
RECODE LIHS_7 (1=7) (2=6) (3=5) (4=4) (5=3) (6=2) (7=1).
RECODE LIHS_8 (1=7) (2=6) (3=5) (4=4) (5=3) (6=2) (7=1).
RECODE LIHS_9 (1=7) (2=6) (3=5) (4=4) (5=3) (6=2) (7=1).
RECODE LIHS_10 (1=7) (2=6) (3=5) (4=4) (5=3) (6=2) (7=1).
EXECUTE.

COMPUTE LIHS_tot=(LIHS_1 + LIHS_2 + LIHS_3 + LIHS_4 + LIHS_5 + LIHS_6 + LIHS_7 + LIHS_8 + LIHS_9 + 
    LIHS_10 + LIHS_11 + LIHS_12) / 12.
EXECUTE.

*sexual quality of life: high score high SQoL.
RECODE SQoL_1 (1=1) (2=2) (3=3) (4=4) (5=5) (6=6).
RECODE SQoL_2 (1=6) (2=5) (3=4) (4=3) (5=2) (6=1).
RECODE SQoL_3 (1=6) (2=5) (3=4) (4=3) (5=2) (6=1).
RECODE SQoL_4 (1=6) (2=5) (3=4) (4=3) (5=2) (6=1).
RECODE SQoL_6 (1=6) (2=5) (3=4) (4=3) (5=2) (6=1).
RECODE SQoL_7 (1=6) (2=5) (3=4) (4=3) (5=2) (6=1).
RECODE SQoL_8 (1=6) (2=5) (3=4) (4=3) (5=2) (6=1).
RECODE SQoL_9 (1=1) (2=2) (3=3) (4=4) (5=5) (6=6).
RECODE SQoL_10 (1=6) (2=5) (3=4) (4=3) (5=2) (6=1).
RECODE SQoL_11 (1=6) (2=5) (3=4) (4=3) (5=2) (6=1).
RECODE SQoL_12 (1=6) (2=5) (3=4) (4=3) (5=2) (6=1).
RECODE SQoL_14 (1=6) (2=5) (3=4) (4=3) (5=2) (6=1).
RECODE SQoL_15 (1=6) (2=5) (3=4) (4=3) (5=2) (6=1).
RECODE SQoL_16 (1=6) (2=5) (3=4) (4=3) (5=2) (6=1).
RECODE SQoL_17 (1=6) (2=5) (3=4) (4=3) (5=2) (6=1).
EXECUTE.

COMPUTE SQoL_tot=MEAN(SQoL_1,SQoL_2,SQoL_3,SQoL_4,SQoL_5,SQoL_6,SQoL_7,SQoL_8,SQoL_9,SQoL_10,
    SQoL_11,SQoL_12,SQoL_13,SQoL_14,SQoL_15,SQoL_16,SQoL_17,SQoL_18).
EXECUTE.


*SELECTING SUBSET.
*selecting lesbian subset.
USE ALL.
COMPUTE filter_$=(self_def <= 1).
VARIABLE LABELS filter_$ 'self_def <= 1 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.
*selecting bisexual subset.
USE ALL.
COMPUTE filter_$=(self_def = 2).
VARIABLE LABELS filter_$ 'self_def = 2 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.
*selecting lesbians an bisexuals (excluding heterosexuals).
USE ALL.
COMPUTE filter_$=(self_def  <= 2).
VARIABLE LABELS filter_$ 'self_def  <= 2 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.


*DESCRIPTIVE STATISTICS.
COMPUTE age_number=age + 16.
EXECUTE.
FREQUENCIES VARIABLES=age_number
  /FORMAT=NOTABLE
  /NTILES=4
  /STATISTICS=STDDEV MINIMUM MAXIMUM MEAN MEDIAN MODE
  /ORDER=ANALYSIS.
FREQUENCIES VARIABLES=relation edu
  /ORDER=ANALYSIS.
*comparison age bisexual and lesbian.
T-TEST GROUPS=self_def(1 2)
  /MISSING=ANALYSIS
  /VARIABLES=age_number
  /ES DISPLAY(TRUE)
  /CRITERIA=CI(.95).


*mean difference between lesbian and bisexual women for SQoL and Internalized homonegativity.
T-TEST GROUPS=self_def(1 2)
  /MISSING=ANALYSIS
  /VARIABLES=SQoL_tot LIHS_sum
  /ES DISPLAY(TRUE)
  /CRITERIA=CI(.95).

*multiple regression.
REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA
  /CRITERIA=PIN(.05) POUT(.10) TOLERANCE(.0001)
  /NOORIGIN 
  /DEPENDENT SQoL_tot
  /METHOD=ENTER LIHS_sum age_number self_def.

*exploratory analysis for tole of monogamy (as requested by the editor).
RECODE relation (1=1) (4=1) (2=2) (3=2) (5=2) (ELSE=SYSMIS) INTO Monogamy.
EXECUTE.
REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA
  /CRITERIA=PIN(.05) POUT(.10) TOLERANCE(.0001)
  /NOORIGIN 
  /DEPENDENT SQoL_tot
  /METHOD=ENTER age LIHS_sum self_def Monogamy.


RELIABILITY
  /VARIABLES=SQoL_1 SQoL_2 SQoL_3 SQoL_4 SQoL_5 SQoL_6 SQoL_7 SQoL_8 SQoL_9 SQoL_10 SQoL_11 SQoL_12 
    SQoL_13 SQoL_14 SQoL_15 SQoL_16 SQoL_17 SQoL_18
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /SUMMARY=TOTAL.

RELIABILITY
  /VARIABLES=LIHS_1 LIHS_2 LIHS_3 LIHS_4 LIHS_5 LIHS_6 LIHS_7 LIHS_8 LIHS_9 LIHS_10 LIHS_11 LIHS_12
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /SUMMARY=TOTAL.


