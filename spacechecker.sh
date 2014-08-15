#!/bin/sh

# Start of new script

THRESHOLD=70

used=$(df | grep sda2 | awk {'print $5'})

echo $used

# sleep 5

echo $used | tr -d "%" > value.txt

cat value.txt

value=$(<value.txt)

echo $value

# sleep 5

if [ $value -gt $THRESHOLD ] ; then
        service rsyslog reload
else
echo "Nothing to be done" > output-`date +%F_%T`.txt

fi



