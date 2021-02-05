#!/bin/bash

ps aux --no-heading | sort -n -k3 -r | head -n 10 | awk '{print "Process name: " $11 " Username: " $1 " Pid: " $2}'
