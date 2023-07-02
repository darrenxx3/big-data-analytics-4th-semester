DATA roster; /*Creates a data set 'roster' */
	
	INPUT name $ sex $ id $ stand pretest first second final; /* $ declares 'name' and 'id'*/
															  /* as character variables    */
	composite = pretest + first + second + final;
	
	LABEL stand = 'academic standing in college';
	
DATALINES;
Vincencius 	m 1 1 9 31 45 .
Obie 		m 2 4 18 46 53 54
Michelle 	f 3 1 7 38 33 43
Rendy 		m 4 2 12 34 50 32
Emillio 	m 5 2 14 31 47 43
Darren 		m 6 4 20 45 51 57
Stevanus 	m 7 4 17 34 46 50
Jessica		f 8 2 12 44 52 47
Decky 		m 9 4 18 50 57 56
Jericho 	m 10 3 15 29 39 42
Rheinald 	m 11 3 15 24 48 49
Ilone 		f 12 4 18 48 54 54
Jachinta 	f 13 4 21 48 52 42
Sherly 		f 14 1 11 32 41	40
RUN;

PROC PRINT; RUN;

PROC MEANS DATA=roster; RUN;

PROC RANK DESCENDING OUT=temp;
	 VAR composite;
	 RANKS rank;
RUN;

PROC SORT;
	BY rank;
RUN;

PROC PRINT DATA=temp;
RUN;