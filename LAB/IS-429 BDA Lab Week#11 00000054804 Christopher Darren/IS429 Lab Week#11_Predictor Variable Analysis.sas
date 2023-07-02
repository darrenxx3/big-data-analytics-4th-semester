/* Import Clean.csv from /home/u63320802/listings_clean.csv to your WORK repository */

PROC IMPORT DATAFILE="/home/u63318200/my_shared_file_links/u59229493/Week#10/CLEAN.csv"
	DBMS=CSV
	OUT= Clean;
	GETNAMES=YES;
RUN;


PROC univariate data=clean; var bedrooms bathrooms beds; run;


PROC FREQ DATA=Clean; TABLES host_count_cat; RUN;

PROC MEANS DATA=Clean;
	CLASS host_count_cat;
	VAR Price Price_Log;
RUN;

/* Create global numeric variables */
PROC CONTENTS NOPRINT DATA=Clean (KEEP=_NUMERIC_ DROP=id host_id
latitude longitude Price Price_Log) OUT=var1 (KEEP=name);
RUN;

PROC SQL NOPRINT;
	SELECT name INTO:varx separated by " " FROM var1;
QUIT;

%PUT &varx;

/* Create correlation analysis */
PROC CORR DATA=Clean;
	VAR &varx.;
RUN;
