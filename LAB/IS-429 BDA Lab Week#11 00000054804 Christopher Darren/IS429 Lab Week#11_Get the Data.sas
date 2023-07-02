LIBNAME MYDATA BASE "/home/u63318200/sasuser.v94/week11";

FILENAME REFFILE '/home/u63318200/sasuser.v94/week11/listings_clean.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=MYDATA.Listings;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=MYDATA.listings; RUN;
/*end----2.1*/

/*Example work libraries*/

DATA WORK.TEST;
	SET MYDATA.Listings;
RUN;

DATA TEST;
	SET MYDATA.LISTINGS;
RUN;

FILENAME REFFILE2 '/home/u63318200/sasuser.v94/week11/calendar.csv';

PROC IMPORT DATAFILE=REFFILE2
	DBMS=CSV
	OUT=MYDATA.Calendar;
	GETNAMES=YES;
RUN;