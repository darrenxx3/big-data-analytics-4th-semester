/* MEANS */
PROC MEANS DATA=MYDATA.LISTINGS n mean std min max;
 var price accommodates bathrooms;
QUIT;

PROC MEANS DATA=MYDATA.LISTINGS n nmiss min max mean median std ;
 var price accommodates bathrooms;
 class room_type;
QUIT;

/*Develop an 80/20 Split Indicator*/
/*Split data into TRAIN and TEST datasets at an 80/20 split*/
PROC SURVEYSELECT DATA=MYDATA.listings SAMPRATE=0.20 SEED=42
	OUT=Full OUTALL METHOD=SRS;
RUN;

DATA TRAIN TEST;
	SET Full;
	IF Selected=0 THEN OUTPUT TRAIN;ELSE OUTPUT TEST;
	DROP Selected;
RUN;