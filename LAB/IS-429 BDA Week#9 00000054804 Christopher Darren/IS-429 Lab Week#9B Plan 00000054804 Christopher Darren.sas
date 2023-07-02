session server;

/* Start checking for existence of each input table */
exists0=doesTableExist("DIDP25", "RETAIL_ORDERS");
if exists0 == 0 then do;
  print "Table "||"DIDP25"||"."||"RETAIL_ORDERS" || " does not exist.";
  print "UserErrorCode: 100";
  exit 1;
end;
print "Input table: "||"DIDP25"||"."||"RETAIL_ORDERS"||" found.";
exists1=doesTableExist("DIDP25", "NC_CUSTOMERS");
if exists1 == 0 then do;
  print "Table "||"DIDP25"||"."||"NC_CUSTOMERS" || " does not exist.";
  print "UserErrorCode: 100";
  exit 1;
end;
print "Input table: "||"DIDP25"||"."||"NC_CUSTOMERS"||" found.";
/* End checking for existence of each input table */


  _dp_inputTable="NC_CUSTOMERS";
  _dp_inputCaslib="DIDP25";

  _dp_outputTable="b43dca9c-f72b-4380-a98b-2b1fed1fae44";
  _dp_outputCaslib="CASUSER(christopher.darren@student.umn.ac.id)";

queryCode='
create table "CASUSER(christopher.darren@student.umn.ac.id)"."b43dca9c-f72b-4380-a98b-2b1fed1fae44" {options replace=true label="00000054804"} as

    /* BEGIN statement 760334f8_631b_435d_a475_7053464e94a6            multi_table_join */
    select  distinct 
        t1."CUSTOMER_ID" as "CUSTOMER_ID",
        t1."CUSTOMER_NAME" as "CUSTOMER_NAME",
        t1."CUSTOMER_BIRTHDATE" as "CUSTOMER_BIRTHDATE",
        t1."CUSTOMER_GENDER" as "CUSTOMER_GENDER",
        t1."CUSTOMER_ADDRESS" as "CUSTOMER_ADDRESS",
        t1."CUSTOMER_CITY" as "CUSTOMER_CITY",
        t1."CUSTOMER_STATE" as "CUSTOMER_STATE",
        t1."CUSTOMER_POSTAL_CODE" as "CUSTOMER_POSTAL_CODE",
        t2."STREET_ID" as "STREET_ID",
        t2."ORDER_DATE" as "ORDER_DATE",
        t2."DELIVERY_DATE" as "DELIVERY_DATE",
        t2."ORDER_ID" as "ORDER_ID",
        t2."PRODUCT_ID" as "PRODUCT_ID",
        t2."QUANTITY" as "QUANTITY",
        t2."TOTAL_RETAIL_PRICE" as "TOTAL_RETAIL_PRICE",
        t2."COSTPRICE_PER_UNIT" as "COSTPRICE_PER_UNIT",
        t2."TOTAL_PRICE" as "TOTAL_PRICE",
        t2."ORDER_TYPE" as "ORDER_TYPE"
    
    from
        "DIDP25"."NC_CUSTOMERS" t1

    inner join
        "DIDP25"."RETAIL_ORDERS" t2
        on
            t1."CUSTOMER_ID"=t2."CUSTOMER_ID"

    /* END statement 760334f8_631b_435d_a475_7053464e94a6              multi_table_join */

';
fedSql.ExecDirect result=r status=rc / query=queryCode;
if rc.statusCode != 0 then do;
    print "Error executing fedsql";
    exit 3;
end;
  _dp_inputTable="b43dca9c-f72b-4380-a98b-2b1fed1fae44";
  _dp_inputCaslib="CASUSER(christopher.darren@student.umn.ac.id)";

  _dp_outputTable="NC_CUSTOMER_00000054804CHRISTOPHERDARREN";
  _dp_outputCaslib="CASUSER(christopher.darren@student.umn.ac.id)";

srcCasTable="b43dca9c-f72b-4380-a98b-2b1fed1fae44";
srcCasLib="CASUSER(christopher.darren@student.umn.ac.id)";
tgtCasTable="NC_CUSTOMER_00000054804CHRISTOPHERDARREN";
tgtCasLib="CASUSER(christopher.darren@student.umn.ac.id)";
saveType="sashdat";
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


dropTableIfExists("CASUSER(christopher.darren@student.umn.ac.id)", "b43dca9c-f72b-4380-a98b-2b1fed1fae44");

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
