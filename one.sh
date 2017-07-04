#! /bin/sh
java -Xmx18432M -cp target:lib/ECLA.jar:lib/DTNConsoleConnection.jar core.DTNSim $*
