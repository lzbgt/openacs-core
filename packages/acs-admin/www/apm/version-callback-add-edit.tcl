ad_page_contract {
    Page for editing and adding callbacks. If type is provided we are in edit
    mode.

    @author Peter Marklund
    @creation-date 28 January 2003
    @cvs-id $Id$  
} {
    version_id:integer,notnull    
    {type ""}
}

db_1row package_version_info "select pretty_name, version_name from apm_package_version_info where version_id = :version_id"

set page_title "Add Tcl Callback for $pretty_name $version_name"
set context_bar [ad_context_bar $page_title]
set return_url "version-callbacks?version_id=$version_id"


# Set default values for type and proc name
if { [empty_string_p $type] } {
    # We are in add mode
    set edit_mode_p 0
    set unused_types [apm_unused_callback_types -version_id $version_id]
    set type_options [list]
    foreach unused_type $unused_types {
        lappend type_options [list $unused_type $unused_type]
    }
    set type_value [lindex $type_options 0]
    set proc_value ""
} else {
    # We are in edit mode
    set edit_mode_p 1
    set type_options ""
    set type_value $type
    set proc_value [apm_get_callback_proc -type $type -version_id $version_id]
}

set type_label "Tcl procedure name"
ad_form -name callback -cancel_url $return_url -form {
    {version_id:integer(hidden) 
      {value $version_id}
    }

    {return_url:text(hidden) 
      {value $return_url}
    }

    {edit_mode_p:text(hidden) 
      {value $edit_mode_p}
    }

    {type:text(select)
      {label "Type"}
      {options {$type_options}}
      {value $type_value}
    }

    {proc:text
      {label $type_label}
      {html {size 40 maxlength 300}}
      {value $proc_value}
    }

} -validate {
    {proc
    { ![empty_string_p [info procs ::${proc}]] }
    {The specified procedure name does not exist. Is the -procs.tcl file loaded?}
    }
} -on_submit {
    
    apm_set_callback_proc -type $type -version_id $version_id $proc
    
    ad_returnredirect $return_url
    ad_script_abort
}

if { $edit_mode_p } {
    element set_properties callback type -value $type_value -widget hidden
    element create callback type_inform -widget inform -value $type -label $type_label
}

ad_return_template
