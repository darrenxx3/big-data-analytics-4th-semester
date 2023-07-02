/* Data set code to copy a data table */
data WORK.MYCARS;
	set SASHELP.CARS;
run;

/* Proc code to copy a data table */
proc copy out=WORK in=SASHELP;
	SELECT CLASS;
run;
