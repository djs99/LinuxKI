#!/bin/bash
# d3_csv.sh script  --  run script to create JS HTML files based in CSV data
# @(#) (C) Copyright 2000-2012 Hewlett-Packard Development Company, L.P.
#
# version 1.1   07/24/2013   creates D3 HTML charts based on CSV data
# version 1.2   05/06/2015   change D3 to a locally hosted path

# DESCRIPTION:
#
#   d3_csv.sh will place copies of D3 based javascript HTML files in the PWD
#   and each of them will try to read specific CSV file data.  The GUI charts
#   created are interactive and provide a more visaul way to review the large
#   datasets presented int he CSV data.  The CSV files are expected to be in 
#   format generated by the kiinfo tool using the 'csv' option.  There are 
#   specific column header names used to set line colors so nono-std CSV files 
#   may not present in the proper color scheme.
#
# USAGE:
#
#   ./d3_csv.sh
#
EVDIR=/opt/linuxki/experimental/vis
SAVED_PWD=$PWD
OS=`uname`

for tag in `ls ki*.????_????* | grep -v "ki.err" | awk '{print substr($1,match($1,"[0-9][0-9][0-9][0-9]_[0-9][0-9][0-9][0-9]"),9)}' | sort | uniq `
do
  cd $SAVED_PWD
  if [ -f kidsk.$tag.csv ] ; then
    rm -f kidsk.csv
    cat kidsk.$tag.csv | sed 's/ //g' > kidsk.csv	
    ln -s $EVDIR/kidsk.html ./kidsk.html
  fi

  if [ -f kifile.$tag.csv ] ; then
    rm -f kifile.csv
    ln -s kifile.$tag.csv kifile.csv
    ln -s $EVDIR/kifile.html ./kifile.html
  fi

  if [ -f kipid.$tag.csv ] ; then
    rm -f kipid_io.csv
    rm -f kipid_sched.csv
    ln -s kipid.$tag.csv kipid.csv

#   The following script splits out the kipid csv data into scheduling
#   and I/O related data:

    $EVDIR/kipid_awk_csv.sh kipid.csv
    ln -s $EVDIR/kipid_io.html ./kipid_io.html
    ln -s $EVDIR/kipid_sched.html ./kipid_sched.html
  fi

  if [ -f kirunq.$tag.csv ] ; then
    rm -f kirunq.csv
    ln -s kirunq.$tag.csv kirunq.csv
    ln -s $EVDIR/kirunq.html ./kirunq.html
  fi

  if [ -f kiwait.$tag.csv ] ; then
    rm -f kiwait.csv
    ln -s kiwait.$tag.csv kiwait.csv
    ln -s $EVDIR/kiwait.html ./kiwait.html
  fi

  if [ -f kisock.$tag.csv ] ; then
    rm -f kisock.csv
    head -1 kisock.$tag.csv > kisock.csv
    cat kisock.$tag.csv | sort -n -r -k 14,14 -t "," | head -80 | grep -v Local_IP >>  kisock.csv 
    ln -s $EVDIR/network.html ./network.html
    ln -s $EVDIR/socket.html ./socket.html
  fi


done
