ad_page_contract {

    Displays information about a type.

    @cvs-id $Id$

} {
    version_id:optional
    type
} -properties {
    title:onevalue
    contextbar:onevalue
    documentation:onevalue
}

if { ![info exists version_id] && \
        [regexp {^([^ /]+)/} $type "" package_key] } {
    db_0or1row version_id_from_package_key {
        select version_id 
          from apm_enabled_package_versions 
         where package_key = :package_key
    }
}
 
if [exists_and_not_null version_id] {
    set public_p [api_set_public $version_id]
} else {
    set public_p [api_set_public]
}

set context_bar_elements [list]

if { [info exists version_id] } {
    db_1row package_info_from_version_id {
        select package_name, package_key, version_name
          from apm_package_version_info
         where version_id = :version_id
    }
    lappend context_bar_elements [list "package-view?version_id=$version_id&kind=types" "$package_name $version_name"]
}

lappend context_bar_elements $type

set title $type
set context_bar [eval ad_context_bar $context_bar_elements]
set documentation [api_type_documentation $type]