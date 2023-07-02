DATA trans;
	INPUT test1 test2 test3;
	final=(test1+test2+test3)/3;
	LABEL test1='first test' 
	test2='second test' 
	test3='third test' 
	final='overall score';
	
DATALINES;
60 80 99
50 87 65
100 99 98
RUN;

PROC PRINT DATA=trans;
RUN;
PROC MEANS;
RUN;