ad_page_contract {
    Erases a portrait

    @cvs-id $Id$
} {
    {return_url "" }
    {user_id ""}
} -properties {
    context:onevalue
    export_vars:onevalue
    admin_p:onevalue
}

set current_user_id [ad_conn user_id]

if {$user_id eq ""} {
    set user_id $current_user_id
    set admin_p 0
} else {
    set admin_p 1
}

ad_require_permission $user_id "write"

if {$admin_p} {
    set context [list [list "./?user_id=$user_id" "User's Portrait"] "Erase"]
} else {
    set context [list [list "./" "Your Portrait"] "Erase"]
}

set export_vars [export_form_vars user_id return_url]

