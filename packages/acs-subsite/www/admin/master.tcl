# /packages/acs-subsite/www/admin/master.tcl

# Ensures variables needed by master.adp are defined

if { ![info exists focus] } {
    set focus ""
}	
if { ![info exists title] } {
    set title ""
}	
if { ![info exists context_bar] } {
    set context_bar ""
}	

set context_bar [eval ad_context_bar $context_bar]
