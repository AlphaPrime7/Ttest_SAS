/******************
Input: ttest_p.csv
Output: SAS_Paired_TTest.pdf
Written by:Tingwei Adeck
Date: Oct 5th 2022
Description:T-Tests in SAS
Requirements: Need library called project, ttest_p.csv.
Dataset description: Data obtained from Dr. Gaddis (small dataset)
******************/


%let path=/home/u40967678/sasuser.v94;


libname project
    "&path/sas_umkc/input";

/*FILENAME REFFILE '/home/u40967678/sasuser.v94/sas_umkc/src/chol.csv'*/
filename ttestp
    "&path/sas_umkc/input/ttest_p.csv";
    
ods pdf file=
    "&path/sas_umkc/output/SAS_Paired_TTest.pdf"; /*I will get used to the ods library in making macros*/
    
options papersize=(8in 4in) nonumber nodate;


/* Assuming items are separated by a space */
/*%let data_list = %str(glucose cholesterol);*/

proc import file= ttestp
    out=project.ttestp
	dbms=csv
	replace;
run;

proc univariate data=project.ttestp normal;
	var New_Test_score;
	var Old_Test_score;
run;

/*perform paired samples t-test*/
proc ttest data=project.ttestp alpha=.05;
    paired New_Test_score*Old_Test_score;
run;

/*perform paired samples t-test*/
proc ttest data=project.ttestp alpha=.025;
    paired New_Test_score*Old_Test_score;
run;

%macro cohens_ttest(data=,var1=,var2=,H0=);
proc sql;
    create table project.cdcalc as
        select avg(&var1-&var2) as mean, std(&var1-&var2) as stdev
	from &data;
quit;

title 'Cohens D';
data project.cd_pttest;
set project.cdcalc;
cohens_d = (mean-&H0)/stdev;
proc print data=project.cd_pttest;
run;

%mend sortandprint;

%cohens_ttest(data=project.ttestp,var1=New_Test_score,var2=Old_Test_score,H0=0);
	

ods pdf close;