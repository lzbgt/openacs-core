ad_page_contract {

    Display all readable unmounted packages

  @author bquinn@arsdigita.com
  @creation-date 2000-09-12
  @cvs-id $Id$
} {
}

doc_body_append "[ad_header "Unmounted Packages"]
<h2>Unmounted Packages </h2>
[ad_context_bar [list "index" "Site Map"] "Unmounted Packages"]
<hr>

The following application packages are not mounted anywhere.  You can delete an unmounted package 
by clicking the \"delete\" option.  
<ul>
"

set user_id [ad_conn user_id]

db_foreach packages_normal_select {
  select package_id, acs_object.name(package_id) as name
  from
  apm_packages
  where (acs_permission.permission_p(package_id, :user_id, 'read') = 't' or
         acs_permission.permission_p(package_id, acs.magic_object_id('the_public'), 'read') = 't')
    and apm_package.singleton_p(package_key) = 0
    and not exists (select 1
                    from site_nodes
                    where object_id = package_id)  
  order by name
} {
    doc_body_append "<li>$name \[<a href=instance-delete?[export_url_vars package_id]>delete</a>\]"
}

doc_body_append "</ul> <p />

The following services are singleton packages and are not meant to
be mounted anywhere.  Be careful not to delete a service that is in use.

<ul>"

db_foreach packages_singleton_select {
  select package_id, acs_object.name(package_id) as name
  from
  apm_packages
  where (acs_permission.permission_p(package_id, :user_id, 'read') = 't' or
         acs_permission.permission_p(package_id, acs.magic_object_id('the_public'), 'read') = 't')
    and apm_package.singleton_p(package_key) = 1
    and not exists (select 1
                    from site_nodes
                    where object_id = package_id)  
  order by name
} {
    doc_body_append "<li>$name \[<a href=instance-delete?[export_url_vars package_id]>delete</a>\]"
}


doc_body_append "
</ul>

[ad_footer]
"
