#!/bin/sh
# A shell script to invoke some sample curl commands on a Linux/Mac machine 
# against a running container image of the app-specific Gilhari microservice 
# gilhari_relationships_implicit_attribs_example:1.0
# 
# The responses are recorded in a log file (curl.log).
#
# Note that these curl commands use a mapped port number of 80
# even though the port number exposed by the app-specific 
# microservice may be different (e.g., 8081) inside the container shell.
# If you want to use these curl commands from inside the
# container shell on the host machine, you may have to use
# the exposed port number (e.g., 8081) instead.
#
# Note: Using the INLINE attributes feature such that attribute values of 
# an E object are stored in the same table row as the 
# attribute values of the containing D object.

echo -e "** BEGIN OUTPUT **" > curl.log

echo "** Delete all E objects"  >> curl.log
curl -X DELETE "http://localhost:80/gilhari/v1/E" >> curl.log
echo "" >> curl.log

echo "** Delete all D objects (and their referenced INLINEed E objects) to start fresh" >> curl.log
curl -X DELETE "http://localhost:80/gilhari/v1/D" >> curl.log
echo "" >> curl.log

echo "** Insert one D object with one referenced E object" >> curl.log
curl -X POST "http://localhost:80/gilhari/v1/D"  -H 'Content-Type: application/json' -d '{"entity":{"dId":1,"dString":"dString_1","dE":{"eId":100,"eString":"eString_100"]}}' >> curl.log
echo -e "" >> curl.log

echo "** Query all D objects (and their referenced E objects)" >> curl.log
curl -X GET "http://localhost:80/gilhari/v1/D"  -H "Content-Type: application/json" >> curl.log
echo "" >> curl.log

echo "** Shallow Query of all D objects will still fetch the attribute values of the INLINed E objects stored in the same table row" >> curl.log
curl -X GET "http://localhost:80/gilhari/v1/D?deep=false"  -H "Content-Type: application/json" >> curl.log
echo "" >> curl.log

echo "** Insert one D object with one referenced E object" >> curl.log
curl -X POST "http://localhost:80/gilhari/v1/D"  -H "Content-Type: application/json"  -d '{"entity":{"dId":2,"dString":"dString_2","dE":{"eId":200,"eString":"eString_200"}}}' >> curl.log
echo "" >> curl.log

echo "** Insert one D object without any referenced E objects" >> curl.log
curl -X POST "http://localhost:80/gilhari/v1/D"  -H "Content-Type: application/json"  -d '{"entity":{"dId":3,"dString":"dString_3"}}' >> curl.log
echo "" >> curl.log

echo "** Query all D objects (and their referenced E objects) objects" >> curl.log
curl -X GET "http://localhost:80/gilhari/v1/D"  -H "Content-Type: application/json"
echo "" >> curl.log

echo "** ** Shallow Query of all D objects will still fetch the attribute values of the INLINed E objects stored in the same table row" >> curl.log
curl -X GET "http://localhost:80/gilhari/v1/D?deep=false"  -H "Content-Type: application/json" >> curl.log
echo "" >> curl.log

echo "** Query all D objects (and their referenced D objects) objects where dId>1" >> curl.log
curl -X GET "http://localhost:80/gilhari/v1/D?filter=dId>1"  -H "Content-Type: application/json" >> curl.log
echo "" >> curl.log

echo "** Query all D objects (and their referenced E objects) objects where the related E object's eId > 100 (using a path-expression)" >> curl.log
curl -X GET "http://localhost:80/gilhari/v1/D?filter=jdxObject.dE_eId>100>100"  -H "Content-Type: application/json" >> curl.log
echo "" >> curl.log

echo "** Query the count of D objects" >> curl.log
curl -X GET "http://localhost:80/gilhari/v1/D/getAggregate?attribute=dId&aggregateType=COUNT"  -H "Content-Type: application/json" >> curl.log
echo "" >> curl.log

echo "** Query all E objects" >> curl.log
curl -X GET "http://localhost:80/gilhari/v1/E"  -H "Content-Type: application/json" >> curl.log
echo "" >> curl.log

echo ** Delete all E objects >> curl.log
curl -X DELETE "http://localhost:80/gilhari/v1/E" >> curl.log
echo "" >> curl.log

echo "** Query the count of E objects" >> curl.log
curl -X GET "http://localhost:80/gilhari/v1/E/getAggregate?attribute=eId&aggregateType=COUNT"  -H "Content-Type: application/json" >> curl.log
echo "" >> curl.log


echo "** Insert one E object independently (this wll be stored in a table designated for E, that is, not in the table for D)" >> curl.log
curl -X POST "http://localhost:80/gilhari/v1/E"  -H "Content-Type: application/json"  -d "{"entity":{"eId":5000,"eString":"eString_5000"}}" >> curl.log
echo "" >> curl.log

echo "** Query all E objects" 
curl -X GET "http://localhost:%port%/gilhari/v1/E"  -H "Content-Type: application/json" >> curl.log
echo "" >> curl.log

echo "** Delete all E objects"  >> curl.log
curl -X DELETE "http://localhost:80/gilhari/v1/E" >> curl.log
echo "" >> curl.log

echo "** Delete all D objects (and their referenced INLINEed E objects)"  >> curl.log
curl -X DELETE "http://localhost:80/gilhari/v1/D" >> curl.log
echo "" >> curl.log

echo "** Query the count of all D objects" >> curl.log
curl -X GET "http://localhost:80/gilhari/v1/D/getAggregate?attribute=dId&aggregateType=COUNT"  -H "Content-Type: application/json" >> curl.log
echo "" >> curl.log

echo "** END OUTPUT **" >> curl.log
echo "" >> curl.log

cat curl.log
