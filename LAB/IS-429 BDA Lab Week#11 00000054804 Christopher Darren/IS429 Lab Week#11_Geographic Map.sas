/*Create Geographic Map*/
ODS GRAPHICS / RESET WIDTH=6.4 in HEIGHT=4.8 in;
PROC SGMAP plotdata = MYDATA.LISTINGS;
	openstreetmap;
	scatter x=longitude y=latitude /
markerattrs=(size=3 symbol=circle);
RUN;
ODS GRAPHICS / RESET;

/*Neighborhood Group Map View*/
ODS GRAPHICS / RESET WIDTH=6.4in HEIGHT=4.8in;
PROC SGMAP plotdata=MYDATA.LISTINGS;
	openstreetmap;
	scatter x=longitude y=latitude /
	group=neighbourhood_group_cleansed
	name='scatterPlot' markerattrs=(size=3 symbol=circle);
	keylegend 'scatterPlot' /
	title='neighbourhood_group_cleansed';
RUN;
ODS GRAPHICS / RESET;