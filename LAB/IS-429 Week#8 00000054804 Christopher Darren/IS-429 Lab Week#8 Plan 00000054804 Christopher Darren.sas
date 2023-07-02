session server;

/* Start checking for existence of each input table */
exists0=doesTableExist("DIDP25", "BANK_CUSTOMERS");
if exists0 == 0 then do;
  print "Table "||"DIDP25"||"."||"BANK_CUSTOMERS" || " does not exist.";
  print "UserErrorCode: 100";
  exit 1;
end;
print "Input table: "||"DIDP25"||"."||"BANK_CUSTOMERS"||" found.";
/* End checking for existence of each input table */


  _dp_inputTable="BANK_CUSTOMERS";
  _dp_inputCaslib="DIDP25";

  _dp_outputTable="f69c2242-35d4-47b1-9079-e9defc82be10";
  _dp_outputCaslib="DIDP25";

    simple.groupByInfo /
    table ={ name="BANK_CUSTOMERS" caslib="DIDP25"}
    inputs = {"CUST_ID"}
    casout = {replace=1, name="f69c2242-35d4-47b1-9079-e9defc82be10" caslib="DIDP25"}
    includeMissing=TRUE generatedColumns={"NONE"};
  _dp_inputTable="f69c2242-35d4-47b1-9079-e9defc82be10";
  _dp_inputCaslib="DIDP25";

  _dp_outputTable="f69c2242-35d4-47b1-9079-e9defc82be10";
  _dp_outputCaslib="DIDP25";

dataStep.runCode result=r status=rc / code='/* BEGIN data step with the output table                                           data */
data "f69c2242-35d4-47b1-9079-e9defc82be10" (caslib="DIDP25" label="00000054804 Christopher Darren" promote="no");

    length
       "Last_Name"n $ 64
       "First_Name"n $ 64
    ;
    label
        "Last_Name"n=""
        "First_Name"n=""
    ;

    /* Set the input                                                                set */
    set "f69c2242-35d4-47b1-9079-e9defc82be10" (caslib="DIDP25"  );

    /* BEGIN statement 192d33e0_da9c_4744_8ec9_c78725f2bd49               dqstandardize */
    "CUSTOMER_NAME"n = dqstandardize ("CUSTOMER_NAME"n, "Name", "ENUSA");
    /* END statement 192d33e0_da9c_4744_8ec9_c78725f2bd49                 dqstandardize */

    /* BEGIN statement a97d2017_5881_4d4a_8729_435e2435f21e                     dqparse */
    length "a97d2017_5881_4d4a_8729_435e2435f21e"n varchar(1024);

    "a97d2017_5881_4d4a_8729_435e2435f21e"n = dqParse("CUSTOMER_NAME"n, "Name", "ENUSA");

    "Last_Name"n = dqParseTokenGet("a97d2017_5881_4d4a_8729_435e2435f21e"n, "Family Name", "Name", "ENUSA");
    "First_Name"n = dqParseTokenGet("a97d2017_5881_4d4a_8729_435e2435f21e"n, "Given Name", "Name", "ENUSA");

    drop "a97d2017_5881_4d4a_8729_435e2435f21e"n;
    /* END statement a97d2017_5881_4d4a_8729_435e2435f21e                       dqparse */
/* END data step                                                                    run */
run;
';
if rc.statusCode != 0 then do;
  print "Error executing datastep";
  exit 2;
end;
  _dp_inputTable="f69c2242-35d4-47b1-9079-e9defc82be10";
  _dp_inputCaslib="DIDP25";

  _dp_outputTable="BANK_CUSTOMERS_00000054804";
  _dp_outputCaslib="DIDP25";

srcCasTable="f69c2242-35d4-47b1-9079-e9defc82be10";
srcCasLib="DIDP25";
tgtCasTable="BANK_CUSTOMERS_00000054804";
tgtCasLib="DIDP25";
saveType="sashdat";
tgtCasTableLabel="00000054804 Christopher Darren";
replace=1;
saveToDisk=0;

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


dropTableIfExists("DIDP25", "f69c2242-35d4-47b1-9079-e9defc82be10");

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
