/*Week#7C*/
proc transpose data=sashelp.failure
	out=work.failure_transposed(drop=_NAME_);
	id cause;
	by process day;
quit;