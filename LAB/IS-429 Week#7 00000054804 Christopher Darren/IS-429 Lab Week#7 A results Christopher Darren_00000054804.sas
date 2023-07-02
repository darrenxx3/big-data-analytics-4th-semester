filename myfile "/home/u63318200/sasuser.v94/rawfile.txt";
data work.ChristopherDarren00000054804;
	infile myfile;
	input Name $ Sex $ Age Height Weight;
run;