/******************
Input: ttest.sav
Output: SAS_Ind_TTest.pdf
Written by:Tingwei Adeck
Date: Oct 5th 2022
Description:T-Tests in SAS
Requirements: Need library called project, ttest.csv.
Dataset description: Data obtained from Dr. Gaddis (small dataset)
******************/


%let path=/home/u40967678/sasuser.v94;


libname project
    "&path/sas_umkc/input";

/*FILENAME REFFILE '/home/u40967678/sasuser.v94/sas_umkc/src/chol.csv'*/
filename ttest
    "&path/sas_umkc/input/ttest.sav";
    
ods pdf file=
    "&path/sas_umkc/output/SAS_Ind_TTest.pdf"; /*I will get used to the ods library in making macros*/
    
options papersize=(8in 4in) nonumber nodate;


/* Assuming items are separated by a space */
/*%let data_list = %str(glucose cholesterol);*/

proc import file= ttest
    out=project.ttest
	dbms=sav
	replace;
run;

/*
proc format;
    value Class_test_taken_num
        'New Test - Class a' = 1
        'Old Test - Class b' = 2;
run;

data project.ttest_recode;
    set project.ttest;
     format Class_test_taken Class_test_taken_num.;
run;
*/

data project.ttest_recode;
    set project.ttest;
    if Class_test_taken = 'New Test - Class a' then Class_test_taken = 1;
    else if Class_test_taken = 'New Test - Class b' then Class_test_taken = 2;

/*perform with Levene's test*/
proc glm data = project.ttest_recode;
  	class Class_test_taken;
    model  TestScore = Class_test_taken;
    means  Class_test_taken / hovtest=levene(type=abs);
run;

/*perform a 2-samples t-test*/
proc ttest data=project.ttest_recode sides=2 alpha=0.05  h0=0;
    class Class_test_taken;
    var TestScore;
run;

ods pdf close;