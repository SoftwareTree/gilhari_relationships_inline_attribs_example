REM  A script to invoke some sample curl commands on a Windows machine
REM  against a running container image of the app-specific Gilhari microservice 
REM  gilhari_relationships_implicit_attribs_example:1.0.
REM
REM  The responses are recorded in a log file (curl.log).
REM
REM  Note that these curl commands use a default mapped port number of 80
REM  even though the port number exposed by the app-specific
REM  microservice may be different (e.g., 8081) inside the container shell.
REM
REM  You may optionally specify a non-default port number as the first 
REM  command line argument to this script. For example, to spcify a 
REM  port number of 8899, use the following command:
REM     curlCommands 8899
REM
REM  Note: Using the INLINE attributes feature such that attribute values of 
REM        an E object are stored in the same table row as the 
REM        attribute values of the containing D object.

IF %1.==. GOTO DefaultPort
SET port=%1
GOTO Proceed

:DefaultPort
SET port=80
GOTO Proceed

:Proceed

echo ** BEGIN OUTPUT ** > curl.log
echo. >> curl.log
echo. >> curl.log

echo Using PORT number %port% >> curl.log
echo. >> curl.log
echo. >> curl.log

echo ** Delete all E objects  to start fresh >> curl.log
curl -X DELETE "http://localhost:%port%/gilhari/v1/E" >> curl.log
echo. >> curl.log
echo. >> curl.log

echo ** Delete all D objects (and their referenced E objects)  to start fresh >> curl.log
curl -X DELETE "http://localhost:%port%/gilhari/v1/D" >> curl.log
echo. >> curl.log
echo. >> curl.log

echo ** Insert one D object with one referenced E object >> curl.log
curl -X POST "http://localhost:%port%/gilhari/v1/D"  -H "Content-Type: application/json"  -d "{""entity"":{""dId"":1,""dString"":""dString_1"",""dE"":{""eId"":100,""eString"":""eString_100""}}}" >> curl.log
echo. >> curl.log
echo. >> curl.log

echo ** Query all D objects (and their referenced E objects) >> curl.log
curl -X GET "http://localhost:%port%/gilhari/v1/D"  -H "Content-Type: application/json" >> curl.log
echo. >> curl.log
echo. >> curl.log

echo ** Shallow Query of all D objects will still fetch the attribute values of the INLINed E objects stored in the same table row >> curl.log 
curl -X GET "http://localhost:%port%/gilhari/v1/D?deep=false"  -H "Content-Type: application/json" >> curl.log
echo. >> curl.log
echo. >> curl.log

echo ** Insert one more D object with one referenced E object >> curl.log
curl -X POST "http://localhost:%port%/gilhari/v1/D"  -H "Content-Type: application/json"  -d "{""entity"":{""dId"":2,""dString"":""dString_2"",""dE"":{""eId"":200,""eString"":""eString_200""}}}" >> curl.log
echo. >> curl.log
echo. >> curl.log

echo ** Insert one more D object without any referenced E objects >> curl.log
curl -X POST "http://localhost:%port%/gilhari/v1/D"  -H "Content-Type: application/json"  -d "{""entity"":{""dId"":3,""dString"":""dString_3""}}" >> curl.log
echo. >> curl.log
echo. >> curl.log

echo ** Query all D objects (and their referenced E objects) objects >> curl.log
curl -X GET "http://localhost:%port%/gilhari/v1/D"  -H "Content-Type: application/json" >> curl.log
echo. >> curl.log
echo. >> curl.log

echo ** Shallow Query of all D objects will still fetch the attribute values of the INLINed E objects stored in the same table row >> curl.log 
curl -X GET "http://localhost:%port%/gilhari/v1/D?deep=false"  -H "Content-Type: application/json" >> curl.log
echo. >> curl.log
echo. >> curl.log

echo "** Query all D objects (and their referenced E objects) objects where dId>1" >> curl.log
curl -X GET "http://localhost:%port%/gilhari/v1/D?filter=dId>1"  -H "Content-Type: application/json" >> curl.log
echo. >> curl.log
echo. >> curl.log

echo "** Query all D objects (and their referenced E objects) objects where the related E object's eId > 100 (using a path-expression)" >> curl.log
curl -X GET "http://localhost:%port%/gilhari/v1/D?filter=jdxObject.dE_eId>100"  -H "Content-Type: application/json" >> curl.log
echo. >> curl.log
echo. >> curl.log

echo ** Query the count of D objects >> curl.log
curl -X GET "http://localhost:%port%/gilhari/v1/D/getAggregate?attribute=dId&aggregateType=COUNT"  -H "Content-Type: application/json" >> curl.log
echo. >> curl.log
echo. >> curl.log

echo ** Query all E objects >> curl.log
curl -X GET "http://localhost:%port%/gilhari/v1/E"  -H "Content-Type: application/json" >> curl.log
echo. >> curl.log
echo. >> curl.log

echo ** Delete all E objects >> curl.log
curl -X DELETE "http://localhost:%port%/gilhari/v1/E" >> curl.log
echo. >> curl.log
echo. >> curl.log

echo ** Query the count of E objects >> curl.log
curl -X GET "http://localhost:%port%/gilhari/v1/E/getAggregate?attribute=eId&aggregateType=COUNT"  -H "Content-Type: application/json" >> curl.log
echo. >> curl.log
echo. >> curl.log

echo ** Delete all D objects (and their referenced E objects)  >> curl.log
curl -X DELETE "http://localhost:%port%/gilhari/v1/D" >> curl.log
echo. >> curl.log
echo. >> curl.log

echo ** Query the count of all D objects >> curl.log
curl -X GET "http://localhost:%port%/gilhari/v1/D/getAggregate?attribute=dId&aggregateType=COUNT"  -H "Content-Type: application/json" >> curl.log
echo. >> curl.log
echo. >> curl.log

echo ** Insert one E object independently (this wll be stored in a table designated for E, that is, not in the table for D)  >> curl.log
curl -X POST "http://localhost:%port%/gilhari/v1/E"  -H "Content-Type: application/json"  -d "{""entity"":{""eId"":5000,""eString"":""eString_5000""}}" >> curl.log
echo. >> curl.log
echo. >> curl.log

echo ** Query all E objects >> curl.log
curl -X GET "http://localhost:%port%/gilhari/v1/E"  -H "Content-Type: application/json" >> curl.log
echo. >> curl.log
echo. >> curl.log

echo ** END OUTPUT ** >> curl.log
echo. >> curl.log

type curl.log

