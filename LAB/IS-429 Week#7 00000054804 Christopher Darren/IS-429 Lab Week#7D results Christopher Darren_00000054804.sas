/*Week#7D 00000054804 Christopher Darren*/

proc transpose data=sashelp.failure
	out=work.ChrisDarren54804_transposed(drop=_NAME_);
	id cause;
	by process day;
quit;

proc means data = work.ChrisDarren54804_transposed n mean max min Q1 median Q3 std;
	class Process;
quit;