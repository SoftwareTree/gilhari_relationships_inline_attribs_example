#!/bin/bash
#  A shell script to invoke some sample curl commands on a Linux/Mac machine 
#  against a running container image of the app-specific Gilhari microservice 
#  gilhari_relationships_inline_attribs_example:1.0.
#
#  This scripts populates some data but does not delete them.
#
#  The responses are recorded in a log file (curl.log).
#
#  Note that these curl commands use a default mapped port number of 80
#  even though the port number exposed by the app-specific
#  microservice may be different (e.g., 8081) inside the container shell.
#
#  You may optionally specify a non-default port number as the first 
#  command line argument to this script. For example, to specify a 
#  port number of 8899, use the following command:
#     curlCommands 8899
#
#  Note: Using the INLINE attributes feature such that attribute values of 
#        an E object are stored in the same table row as the 
#        attribute values of the containing D object.

# Check if a port is provided as an argument, if not, use default port 80
if [ -z "$1" ]; then
    port=80
else
    port=$1
fi

# Log file where output will be saved
log_file="curl.log"

# Start logging
echo "** BEGIN OUTPUT **" > "$log_file"
echo "" >> "$log_file"
echo "" >> "$log_file"

# Log port information
echo "Using PORT number $port" >> "$log_file"
echo "" >> "$log_file"
echo "" >> "$log_file"

# ** Delete all E objects to start fresh
echo "** Delete all E objects to start fresh" >> "$log_file"
curl -X DELETE "http://localhost:$port/gilhari/v1/E" >> "$log_file"
echo "" >> "$log_file"
echo "" >> "$log_file"

# ** Delete all D objects (and their referenced E objects) to start fresh
echo "** Delete all D objects (and their referenced E objects) to start fresh" >> "$log_file"
curl -X DELETE "http://localhost:$port/gilhari/v1/D" >> "$log_file"
echo "" >> "$log_file"
echo "" >> "$log_file"

# ** Insert one D object with one referenced E object
echo "** Insert one D object with one referenced E object" >> "$log_file"
curl -X POST "http://localhost:$port/gilhari/v1/D" -H "Content-Type: application/json" -d '{"entity":{"dId":1,"dString":"dString_1","dE":{"eId":100,"eString":"eString_100"}}}' >> "$log_file"
echo "" >> "$log_file"
echo "" >> "$log_file"

# ** Query all D objects (and their referenced E objects)
echo "** Query all D objects (and their referenced E objects)" >> "$log_file"
curl -X GET "http://localhost:$port/gilhari/v1/D" -H "Content-Type: application/json" >> "$log_file"
echo "" >> "$log_file"
echo "" >> "$log_file"

# ** Shallow Query of all D objects will still fetch the attribute values of the INLINed E objects stored in the same table row
echo "** Shallow Query of all D objects will still fetch the attribute values of the INLINed E objects stored in the same table row" >> "$log_file"
curl -X GET "http://localhost:$port/gilhari/v1/D?deep=false" -H "Content-Type: application/json" >> "$log_file"
echo "" >> "$log_file"
echo "" >> "$log_file"

# ** Insert one more D object with one referenced E object
echo "** Insert one more D object with one referenced E object" >> "$log_file"
curl -X POST "http://localhost:$port/gilhari/v1/D" -H "Content-Type: application/json" -d '{"entity":{"dId":2,"dString":"dString_2","dE":{"eId":200,"eString":"eString_200"}}}' >> "$log_file"
echo "" >> "$log_file"
echo "" >> "$log_file"

# ** Insert one more D object without any referenced E objects
echo "** Insert one more D object without any referenced E objects" >> "$log_file"
curl -X POST "http://localhost:$port/gilhari/v1/D" -H "Content-Type: application/json" -d '{"entity":{"dId":3,"dString":"dString_3"}}' >> "$log_file"
echo "" >> "$log_file"
echo "" >> "$log_file"

# ** Query all D objects (and their referenced E objects)
echo "** Query all D objects (and their referenced E objects)" >> "$log_file"
curl -X GET "http://localhost:$port/gilhari/v1/D" -H "Content-Type: application/json" >> "$log_file"
echo "" >> "$log_file"
echo "" >> "$log_file"

# ** Shallow Query of all D objects will still fetch the attribute values of the INLINed E objects stored in the same table row
echo "** Shallow Query of all D objects will still fetch the attribute values of the INLINed E objects stored in the same table row" >> "$log_file"
curl -X GET "http://localhost:$port/gilhari/v1/D?deep=false" -H "Content-Type: application/json" >> "$log_file"
echo "" >> "$log_file"
echo "" >> "$log_file"

# ** Query all D objects (and their referenced E objects) objects where dId > 1
echo "** Query all D objects (and their referenced E objects) objects where dId>1" >> "$log_file"
curl -X GET "http://localhost:$port/gilhari/v1/D?filter=dId>1" -H "Content-Type: application/json" >> "$log_file"
echo "" >> "$log_file"
echo "" >> "$log_file"

# ** Query all D objects (and their referenced E objects) objects where the related E object's eId > 100
echo "** Query all D objects (and their referenced E objects) objects where the related E object's eId > 100 (using a path-expression)" >> "$log_file"
curl -X GET "http://localhost:$port/gilhari/v1/D?filter=jdxObject.dE_eId>100" -H "Content-Type: application/json" >> "$log_file"
echo "" >> "$log_file"
echo "" >> "$log_file"

# ** Query the count of D objects
echo "** Query the count of D objects" >> "$log_file"
curl -X GET "http://localhost:$port/gilhari/v1/D/getAggregate?attribute=dId&aggregateType=COUNT" -H "Content-Type: application/json" >> "$log_file"
echo "" >> "$log_file"
echo "" >> "$log_file"

# ** Query all E objects; nothing should show because all the E objects have been stored INLINE with the corresponding D objects
echo "** Query all E objects; nothing should show because all the E objects have been stored INLINE with the corresponding D objects" >> "$log_file"
curl -X GET "http://localhost:$port/gilhari/v1/E" -H "Content-Type: application/json" >> "$log_file"
echo "" >> "$log_file"
echo "" >> "$log_file"

# ** Insert one E object independently (this will be stored in a table designated for E, that is, not in the table for D)
echo "** Insert one E object independently (this will be stored in a table designated for E, that is, not in the table for D)" >> "$log_file"
curl -X POST "http://localhost:$port/gilhari/v1/E" -H "Content-Type: application/json" -d '{"entity":{"eId":5000,"eString":"eString_5000"}}' >> "$log_file"
echo "" >> "$log_file"
echo "" >> "$log_file"

# ** Query all E objects
echo "** Query all E objects" >> "$log_file"
curl -X GET "http://localhost:$port/gilhari/v1/E" -H "Content-Type: application/json" >> "$log_file"
echo "" >> "$log_file"
echo "" >> "$log_file"

# End logging
echo "** END OUTPUT **" >> "$log_file"
echo "" >> "$log_file"

# Display the log content
cat "$log_file"
