%let pgm=utl-count-the-number-of-times-a-given-column-has-the-max-value-compared-to-all-other-columns;

Count the number of times a given column has the max value compared to all other columns

github
https://tinyurl.com/hh2vbkjn
https://github.com/rogerjdeangelis/-utl-count-the-number-of-times-a-given-column-has-the-max-value-compared-to-all-other-columns

Stackoverflow R
https://tinyurl.com/58fzar8s
https://stackoverflow.com/questions/77335915/getting-the-rows-occurence-of-max-value-by-column-in-pandas

My solution is a slight variation of the ops problem.
I select the columns that contain a max value

SOLUTIONS

   1  wps sql hardcode
   2  wps sql dynamic
   3  wps r sql dynamic
   4  wps r python dynamic

/*                   _
(_)_ __  _ __  _   _| |_
| | `_ \| `_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
*/

options validvarname=upcase;
libname sd1 "d:/sd1";
data sd1.have;
 input A B C D;
cards4;
   0.02     0.04    0.01    -0.07
   0.04    -0.10    0.30     0.02
  -0.10    -0.02    0.02    -0.01
  -0.02     0.01    0.02     0.00
;;;;
run;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/*   SD1.HAVE total obs=4                            PROCESS                  OUTPUT                                      */
/*                                                                                                                        */
/*  Obs    A        B        C         D                                    LTR    HASMAX                                 */
/*                                                                                                                        */
/*   1    0.02     0.04    0.01*max  -0.07      B has the max, 0.04, Once    B        1                                   */
/*                                              in row 1                                                                  */
/*                                                                                                                        */
/*   2    0.04    -0.10    0.30*max   0.02      C has the max,0.3 ge         C        3                                   */
/*   3   -0.10    -0.02    0.02*max  -0.01      max(of a,b,c,d) in                                                        */
/*   4   -0.02     0.01    0.02*max   0.00      remaining 3 rows                                                          */
/*                                                                                                                        */
/**************************************************************************************************************************/



https://stackoverflow.com/questions/77335915/getting-the-rows-occurence-of-max-value-by-column-in-pandas

/*                                  _   _                   _               _          _
/ | __      ___ __  ___   ___  __ _| | | |__   __ _ _ __ __| | ___ ___   __| | ___  __| |
| | \ \ /\ / / `_ \/ __| / __|/ _` | | | `_ \ / _` | `__/ _` |/ __/ _ \ / _` |/ _ \/ _` |
| |  \ V  V /| |_) \__ \ \__ \ (_| | | | | | | (_| | | | (_| | (_| (_) | (_| |  __/ (_| |
|_|   \_/\_/ | .__/|___/ |___/\__, |_| |_| |_|\__,_|_|  \__,_|\___\___/ \__,_|\___|\__,_|
             |_|                 |_|
*/

proc datasets lib=sd1 nolist nodetails;delete want; run;quit;

proc sql;
  create
     table sd1.want as
  select
     ltr
    ,count(ltr) as HasMax
  from
     (select
       case
         when a ge max(a,b,c,d) then 'A'
         when b ge max(a,b,c,d) then 'B'
         when c ge max(a,b,c,d) then 'C'
         when d ge max(a,b,c,d) then 'D'
         else ''
       end as ltr
     from
       sd1.have)
  group
     by ltr
;quit;


/*___                                   _       _                             _
|___ \  __      ___ __  ___   ___  __ _| |   __| |_   _ _ __   __ _ _ __ ___ (_) ___
  __) | \ \ /\ / / `_ \/ __| / __|/ _` | |  / _` | | | | `_ \ / _` | `_ ` _ \| |/ __|
 / __/   \ V  V /| |_) \__ \ \__ \ (_| | | | (_| | |_| | | | | (_| | | | | | | | (__
|_____|   \_/\_/ | .__/|___/ |___/\__, |_|  \__,_|\__, |_| |_|\__,_|_| |_| |_|_|\___|
                 |_|                 |_|          |___/
*/

/*---- CREATE META DATA ARRAYS                                           ----*/

%array(_vr,values=%varlist(sd1.have));
%let _varlist = %varlist(sd1.have,Od=%str(,));

%put &=_vr2; /* _VR2=B                                                   ----*/
%put &=_vrn; /* _VRN=4                                                   ----*/

%put &=_varlist; /* _VARLIST=A,B,C,D                                     ----*/

proc datasets lib=sd1 nolist nodetails;delete want; run;quit;

proc sql;
  create
     table sd1.want as
  select
     ltr
    ,count(ltr) as HasMax
  from
     (select
       case
         %do_over(_vr, phrase=%str(
         when ? ge max(&_varlist) then "?"))
         else ''
       end as ltr
     from
       sd1.have)
  group
     by ltr
;quit;

proc print data=sd1.want;
run;quit;

/*----  CLEANUP                                                          ----*/
%arraydelete(_vr);
%symdel _varlist / nowarn;

/**************************************************************************************************************************/
/*                                                                                                                        */
/*  Obs    LTR    HASMAX                                                                                                  */
/*                                                                                                                        */
/*   1      B        1                                                                                                    */
/*   2      C        3                                                                                                    */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*____                                         _
|___ /  __      ___ __  ___   _ __   ___  __ _| |
  |_ \  \ \ /\ / / `_ \/ __| | `__| / __|/ _` | |
 ___) |  \ V  V /| |_) \__ \ | |    \__ \ (_| | |
|____/    \_/\_/ | .__/|___/ |_|    |___/\__, |_|
                 |_|                        |_|
*/

/*---- CREATE META DATA ARRAYS                                           ----*/

%array(_vr,values=%varlist(sd1.have));
%let _varlist = %varlist(sd1.have,Od=%str(,));

%put &=_vr2; /* _VR2=B                                                   ----*/
%put &=_vrn; /* _VRN=4                                                   ----*/

%put &=_varlist; /* _VARLIST=A,B,C,D                                     ----*/

proc datasets lib=sd1 nolist nodetails;delete want; run;quit;

libname sd1 "d:/sd1";

%utl_submit_wps64x(resolve('
libname sd1 "d:/sd1";
proc r;
export data=sd1.have r=have;
submit;
library(sqldf);
 want<-sqldf("
  select
     ltr
    ,count(ltr) as HasMax
  from
     (select
       case
         %do_over(_vr, phrase=%str(
         when ? >= max(&_varlist) then `?`))
         else NULL
       end as ltr
     from
       have)
  group
     by ltr
");
want;
endsubmit;
import data=sd1.want r=want;
run;quit;
'));

proc print data=sd1.want;
run;quit;

/*----  CLEANUP                                                          ----*/
%arraydelete(_vr);
%symdel _varlist / nowarn;

/*  _                                      _   _                             _
| || |   __      ___ __  ___   _ __  _   _| |_| |__   ___  _ __    ___  __ _| |
| || |_  \ \ /\ / / `_ \/ __| | `_ \| | | | __| `_ \ / _ \| `_ \  / __|/ _` | |
|__   _|  \ V  V /| |_) \__ \ | |_) | |_| | |_| | | | (_) | | | | \__ \ (_| | |
   |_|     \_/\_/ | .__/|___/ | .__/ \__, |\__|_| |_|\___/|_| |_| |___/\__, |_|
                  |_|         |_|    |___/                                |_|
*/

/*---- CREATE META DATA ARRAYS                                           ----*/

%array(_vr,values=%varlist(sd1.have));
%let _varlist = %varlist(sd1.have,Od=%str(,));

%put &=_vr2; /* _VR2=B                                                   ----*/
%put &=_vrn; /* _VRN=4                                                   ----*/

%put &=_varlist; /* _VARLIST=A,B,C,D                                     ----*/

proc datasets lib=sd1 nolist nodetails;delete want; run;quit;

libname sd1 "d:/sd1";


%utl_submit_wps64x("
libname sd1 'd:/sd1';
proc python;
export data=sd1.have python=have;
submit;
print(have);
from os import path;
import pandas as pd;
import numpy as np;
from pandasql import sqldf;
mysql = lambda q: sqldf(q, globals());
from pandasql import PandaSQL;
pdsql = PandaSQL(persist=True);
sqlite3conn = next(pdsql.conn.gen).connection.connection;
sqlite3conn.enable_load_extension(True);
sqlite3conn.load_extension('c:/temp/libsqlitefunctions.dll');
mysql = lambda q: sqldf(q, globals());
want = pdsql('''
  select
     ltr
    ,count(ltr) as HasMax
  from
     (select
       case
         %do_over(_vr, phrase=%str(
         when ? >= max(&_varlist) then `?`))
         else `0`
       end as ltr
     from
       have)
  group
     by ltr
''');
print(want);
endsubmit;
import data=sd1.want python=want;
run;quit;
");

proc print data=sd1.want;
run;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/* The WPS PYTHON Procedure                                                                                               */
/*                                                                                                                        */
/*   ltr  HasMax                                                                                                          */
/* 0   B       1                                                                                                          */
/* 1   C       3                                                                                                          */
/*                                                                                                                        */
/* WPS Base                                                                                                               */
/*                                                                                                                        */
/* Obs    LTR    HASMAX                                                                                                   */
/*                                                                                                                        */
/*  1      B        1                                                                                                     */
/*  2      C        3                                                                                                     */
/*                                                                                                                        */
/**************************************************************************************************************************/

 /*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
