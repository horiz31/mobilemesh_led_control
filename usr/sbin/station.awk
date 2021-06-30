#!/usr/bin/awk
BEGIN { mac="" ; OFS="," }
/^Station/ { mac=$2 }
/inactive time/ { print mac,$3 }
