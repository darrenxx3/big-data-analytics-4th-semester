/*Week#10 */
/*1. Create Libname - in SAS on Demand for Academics */

libname lib1 "/home/u63318200"; run;
PROC CONTENTS data=lib1._ALL_ NODS;run;

/*2. Import data : Lloaded the csv file into the SAS*/
PROC CONTENTS DATA=WORK.IMPORT; RUN;

/*3. Store the SAS dataset back in SAS on Demand Library*/
DATA LIB1.CS1;
SET WORK.IMPORT; RUN;

/*4.Create copy of file WORK.IMPORT as WORK.CS1. */
DATA WORK.CS1;
SET WORK.IMPORT; RUN;

/*5. Create y variable of Resolution Time = difference*/
DATA WORK.CS1;
SET WORK.CS1;
RESOLUTIONTIME= 'SR Close Date'n-'SR Open Date'n; RUN;
