﻿/*---------------------------------------------------------
  The options statement below should be placed
  before the data step when submitting this code.
---------------------------------------------------------*/
options VALIDMEMNAME=EXTEND VALIDVARNAME=ANY;


/*---------------------------------------------------------
  Before this code can run you need to fill in all the
  macro variables below.
---------------------------------------------------------*/
/*---------------------------------------------------------
  Start Macro Variables
---------------------------------------------------------*/
%let SOURCE_HOST=<Hostname>; /* The host name of the CAS server */
%let SOURCE_PORT=<Port>; /* The port of the CAS server */
%let SOURCE_LIB=<Library>; /* The CAS library where the source data resides */
%let SOURCE_DATA=<Tablename>; /* The CAS table name of the source data */
%let DEST_LIB=<Library>; /* The CAS library where the destination data should go */
%let DEST_DATA=<Tablename>; /* The CAS table name where the destination data should go */

/* Open a CAS session and make the CAS libraries available */
options cashost="&SOURCE_HOST" casport=&SOURCE_PORT;
cas mysess;
caslib _all_ assign;

/* Load ASTOREs into CAS memory */
proc casutil;
  Load casdata="IS-429 Lab Week#14 Gradient boosting is the Winner.sashdat" incaslib="Models" casout="IS-429 Lab Week#14 Gradient boosting is the Winner" outcaslib="casuser" replace;
Quit;

/* Apply the model */
proc cas;
  fcmpact.runProgram /
  inputData={caslib="&SOURCE_LIB" name="&SOURCE_DATA"}
  outputData={caslib="&DEST_LIB" name="&DEST_DATA" replace=1}
  routineCode = "

   /*------------------------------------------
   Generated SAS Scoring Code
     Date             : 30May2023:02:04:26
     Locale           : en_US
     Model Type       : Gradient Boosting
     Interval variable: AgeAtStart(Age at Start)
     Interval variable: Cholesterol
     Interval variable: Height
     Interval variable: Smoking
     Interval variable: Weight
     Class variable   : BP_Status(Blood Pressure Status)
     Class variable   : Sex
     Class variable   : Status
     Response variable: Status
     ------------------------------------------*/
declare object IS-429 Lab Week#14 Gradient boosting is the Winner(astore);
call IS-429 Lab Week#14 Gradient boosting is the Winner.score('CASUSER','IS-429 Lab Week#14 Gradient boosting is the Winner');
   /*------------------------------------------*/
   /*_VA_DROP*/ drop 'I_Status'n 'P_StatusAlive'n 'P_StatusDead'n;
length 'I_Status_10929'n $8;
      'I_Status_10929'n='I_Status'n;
'P_StatusAlive_10929'n='P_StatusAlive'n;
'P_StatusDead_10929'n='P_StatusDead'n;
   /*------------------------------------------*/
";

run;
Quit;

/* Persist the output table */
proc casutil;
  Save casdata="&DEST_DATA" incaslib="&DEST_LIB" casout="&DEST_DATA%str(.)sashdat" outcaslib="&DEST_LIB" replace;
Quit;
