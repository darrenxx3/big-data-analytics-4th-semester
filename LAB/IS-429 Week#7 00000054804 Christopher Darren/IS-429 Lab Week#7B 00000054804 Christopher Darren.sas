/*data work.cars;
	set sashelp.cars;
	row_nums=_N_;
run;*/

/*proc sort data = sashelp.cars out=work.cars2;
	by Make Type;
quit;*/

/*data work.cars3;
	set work.cars2;
	by Make Type;
	if FIRST.Make and FIRST.TYPE then output;
	if NOT FIRST.Make and FIRST.Type then output;*/
	
data work.ChristopherDarren00000054804;
	set work.cars2;
	by Make;
	if FIRST.Make then sequence=1;
	else sequence=sequence+1;
	retain sequence;
	if LAST.Make then put "There are " sequence "of " make;
run;