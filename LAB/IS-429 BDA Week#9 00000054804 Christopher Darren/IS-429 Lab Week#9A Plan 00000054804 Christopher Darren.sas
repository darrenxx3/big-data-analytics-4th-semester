session server;

/* Start checking for existence of each input table */
exists0=doesTableExist("DIDP25", "CUSTOMERS");
if exists0 == 0 then do;
  print "Table "||"DIDP25"||"."||"CUSTOMERS" || " does not exist.";
  print "UserErrorCode: 100";
  exit 1;
end;
print "Input table: "||"DIDP25"||"."||"CUSTOMERS"||" found.";
/* End checking for existence of each input table */


  _dp_inputTable="CUSTOMERS";
  _dp_inputCaslib="DIDP25";

  _dp_outputTable="e5bdef6e-bbbf-4e1b-81e5-855d77987146";
  _dp_outputCaslib="CASUSER(christopher.darren@student.umn.ac.id)";

dataStep.runCode result=r status=rc / code='/* BEGIN data step with the output table                                           data */
data "e5bdef6e-bbbf-4e1b-81e5-855d77987146" (caslib="CASUSER(christopher.darren@student.umn.ac.id)" label="00000054804 Christopher Darren" promote="no");

    length
       "Last_Name"n varchar(50)
       "First_Name"n varchar(50)
       "CUSTOMER_NAME_MC"n varchar(256)
    ;
    label
        "Last_Name"n=""
        "First_Name"n=""
    ;

    /* Set the input                                                                set */
    set "CUSTOMERS" (caslib="DIDP25"  );

    /* BEGIN statement 192d33e0_da9c_4744_8ec9_c78725f2bd49               dqstandardize */
    "CUSTOMER_NAME"n = dqstandardize ("CUSTOMER_NAME"n, "Name", "ENUSA");
    /* END statement 192d33e0_da9c_4744_8ec9_c78725f2bd49                 dqstandardize */

    /* BEGIN statement 192d33e0_da9c_4744_8ec9_c78725f2bd49               dqstandardize */
    "CUSTOMER_ADDRESS"n = dqstandardize ("CUSTOMER_ADDRESS"n, "Address", "ENUSA");
    /* END statement 192d33e0_da9c_4744_8ec9_c78725f2bd49                 dqstandardize */

    /* BEGIN statement 192d33e0_da9c_4744_8ec9_c78725f2bd49               dqstandardize */
    "CUSTOMER_CITY"n = dqstandardize ("CUSTOMER_CITY"n, "City", "ENUSA");
    /* END statement 192d33e0_da9c_4744_8ec9_c78725f2bd49                 dqstandardize */

    /* BEGIN statement 192d33e0_da9c_4744_8ec9_c78725f2bd49               dqstandardize */
    "CUSTOMER_STATE"n = dqstandardize ("CUSTOMER_STATE"n, "State/Province (Full Name)", "ENUSA");
    /* END statement 192d33e0_da9c_4744_8ec9_c78725f2bd49                 dqstandardize */

    /* BEGIN statement a97d2017_5881_4d4a_8729_435e2435f21e                     dqparse */
    length "a97d2017_5881_4d4a_8729_435e2435f21e"n varchar(1024);

    "a97d2017_5881_4d4a_8729_435e2435f21e"n = dqParse("CUSTOMER_NAME"n, "Name", "ENUSA");

    "Last_Name"n = dqParseTokenGet("a97d2017_5881_4d4a_8729_435e2435f21e"n, "Family Name", "Name", "ENUSA");
    "First_Name"n = dqParseTokenGet("a97d2017_5881_4d4a_8729_435e2435f21e"n, "Given Name", "Name", "ENUSA");

    drop "a97d2017_5881_4d4a_8729_435e2435f21e"n;
    /* END statement a97d2017_5881_4d4a_8729_435e2435f21e                       dqparse */
    /* BEGIN statement 1860e0c9_0597_4b71_8d5a_07174aba9eff                     dqmatch */
    "CUSTOMER_NAME_MC"n = dqmatch ("CUSTOMER_NAME"n, "Name", 85, "ENUSA");
    /* END statement 1860e0c9_0597_4b71_8d5a_07174aba9eff                       dqmatch */

/* END data step                                                                    run */
run;
';
if rc.statusCode != 0 then do;
  print "Error executing datastep";
  exit 2;
end;
  _dp_inputTable="e5bdef6e-bbbf-4e1b-81e5-855d77987146";
  _dp_inputCaslib="CASUSER(christopher.darren@student.umn.ac.id)";

  _dp_outputTable="CUSTOMER_00000054804CHRISTOPHER DARREN";
  _dp_outputCaslib="CASUSER(christopher.darren@student.umn.ac.id)";

srcCasTable="e5bdef6e-bbbf-4e1b-81e5-855d77987146";
srcCasLib="CASUSER(christopher.darren@student.umn.ac.id)";
tgtCasTable="CUSTOMER_00000054804CHRISTOPHER DARREN";
tgtCasLib="CASUSER(christopher.darren@student.umn.ac.id)";
saveType="sashdat";
tgtCasTableLabel="00000054804 Christopher Darren";
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


dropTableIfExists("CASUSER(christopher.darren@student.umn.ac.id)", "e5bdef6e-bbbf-4e1b-81e5-855d77987146");

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
