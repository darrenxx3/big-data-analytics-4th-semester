session server;

/* Start checking for existence of each input table */
exists0=doesTableExist("DIDP25", "CLASS");
if exists0 == 0 then do;
  print "Table "||"DIDP25"||"."||"CLASS" || " does not exist.";
  print "UserErrorCode: 100";
  exit 1;
end;
print "Input table: "||"DIDP25"||"."||"CLASS"||" found.";
/* End checking for existence of each input table */


  _dp_inputTable="CLASS";
  _dp_inputCaslib="DIDP25";

  _dp_outputTable="e0fb2f5a-6705-4a4b-bb85-805fa549961d";
  _dp_outputCaslib="CASUSER(christopher.darren@student.umn.ac.id)";

dataStep.runCode result=r status=rc / code='/* BEGIN data step with the output table                                           data */
data "e0fb2f5a-6705-4a4b-bb85-805fa549961d" (caslib="CASUSER(christopher.darren@student.umn.ac.id)" label="00000054804" promote="no");


    /* Set the input                                                                set */
    set "CLASS" (caslib="DIDP25"  );

    /* BEGIN statement 799e68a5_67e9_40f3_85af_5f4b8f2182b3               simple_filter */
    if
        "Grade"n in("B", "C")
        ;
    /* END statement 799e68a5_67e9_40f3_85af_5f4b8f2182b3                 simple_filter */

    /* BEGIN statement 799e68a5_67e9_40f3_85af_5f4b8f2182b3               simple_filter */
    if
        "Class"n eq "Biology"
        ;
    /* END statement 799e68a5_67e9_40f3_85af_5f4b8f2182b3                 simple_filter */

/* END data step                                                                    run */
run;
';
if rc.statusCode != 0 then do;
  print "Error executing datastep";
  exit 2;
end;
  _dp_inputTable="e0fb2f5a-6705-4a4b-bb85-805fa549961d";
  _dp_inputCaslib="CASUSER(christopher.darren@student.umn.ac.id)";

  _dp_outputTable="CLASS_BIO 00000054804 CHRISTOPHER DARREN";
  _dp_outputCaslib="CASUSER(christopher.darren@student.umn.ac.id)";

srcCasTable="e0fb2f5a-6705-4a4b-bb85-805fa549961d";
srcCasLib="CASUSER(christopher.darren@student.umn.ac.id)";
tgtCasTable="CLASS_BIO 00000054804 CHRISTOPHER DARREN";
tgtCasLib="CASUSER(christopher.darren@student.umn.ac.id)";
saveType="xls";
tgtCasTableLabel="00000054804";
replace=1;
saveToDisk=1;

exists = doesTableExist(tgtCasLib, tgtCasTable);
if (exists !=0) then do;
  if (replace == 0) then do;
    print "Table already exists and replace flag is set to false.";
    exit ({severity=2, reason=5, formatted="Table already exists and replace flag is set to false.", statusCode=9});
  end;
end;

if (saveToDisk == 1) then do;
  /* Save will automatically save as type represented by file ext */
  saveName=tgtCasTable;
  if(saveType != "") then do;
    saveName=tgtCasTable || "." || saveType;
  end;
  table.save result=r status=rc / caslib=tgtCasLib name=saveName replace=replace
    table={
      caslib=srcCasLib
      name=srcCasTable
    };
  if rc.statusCode != 0 then do;
    return rc.statusCode;
  end;
  tgtCasPath=dictionary(r, "name");

  dropTableIfExists(tgtCasLib, tgtCasTable);
  dropTableIfExists(tgtCasLib, tgtCasTable);

  table.loadtable result=r status=rc / caslib=tgtCasLib path=tgtCasPath casout={name=tgtCasTable caslib=tgtCasLib} promote=1;
  if rc.statusCode != 0 then do;
    return rc.statusCode;
  end;
end;

else do;
  dropTableIfExists(tgtCasLib, tgtCasTable);
  dropTableIfExists(tgtCasLib, tgtCasTable);
  table.promote result=r status=rc / caslib=srcCasLib name=srcCasTable target=tgtCasTable targetLib=tgtCasLib;
  if rc.statusCode != 0 then do;
    return rc.statusCode;
  end;
end;


dropTableIfExists("CASUSER(christopher.darren@student.umn.ac.id)", "e0fb2f5a-6705-4a4b-bb85-805fa549961d");

function doesTableExist(casLib, casTable);
  table.tableExists result=r status=rc / caslib=casLib table=casTable;
  tableExists = dictionary(r, "exists");
  return tableExists;
end func;

function dropTableIfExists(casLib,casTable);
  tableExists = doesTableExist(casLib, casTable);
  if tableExists != 0 then do;
    print "Dropping table: "||casLib||"."||casTable;
    table.dropTable result=r status=rc/ caslib=casLib table=casTable quiet=0;
    if rc.statusCode != 0 then do;
      exit();
    end;
  end;
end func;

/* Return list of columns in a table */
function columnList(casLib, casTable);
  table.columnInfo result=collist / table={caslib=casLib,name=casTable};
  ndimen=dim(collist['columninfo']);
  featurelist={};
  do i =  1 to ndimen;
    featurelist[i]=upcase(collist['columninfo'][i][1]);
  end;
  return featurelist;
end func;
