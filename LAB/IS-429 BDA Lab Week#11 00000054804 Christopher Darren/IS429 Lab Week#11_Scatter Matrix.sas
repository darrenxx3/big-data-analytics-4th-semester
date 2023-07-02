/*Run the standardize procedure and Create Scatter Matrix*/

PROC STANDARD DATA=Clean OUT=Stnd_Clean
	MEAN=0 STD=1 REPLACE;
	VAR accommodates bathrooms bedrooms beds guests_included
		minimum_nights maximum_nights availability_30 beds_per_accom bath_per_accom
		poly_accom poly_bath poly_guests poly_min poly_max poly_avail;
RUN;

PROC SGSCATTER DATA=Stnd_Clean;
	TITLE 'Scatter Plot Matrix';
	MATRIX Price_Log accommodates guests_included minimum_nights maximum_nights/
	START=TOPLEFT ELLIPSE = (ALPHA=0.05 TYPE=PREDICTED) NOLEGEND;
RUN;