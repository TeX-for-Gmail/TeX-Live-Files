#!/usr/bin/env wish
wm title . "Warning/Error"
pack [label .l -text $::env(RUNSCRIPT_ERROR_MESSAGE) -wraplength 80] \
    -padx 6 -pady 3
pack [button .q -text "Ok" -command exit] -ipadx 3 -pady 3
