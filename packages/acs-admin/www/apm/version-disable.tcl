ad_page_contract {
    Disables a version of a package.
    @author Jon Salz [jsalz@arsdigita.com]
    @date 17 April 2000
    @cvs-id $Id$
} {
    version_id:integer
}

apm_version_disable -callback apm_dummy_callback $version_id

ns_returnredirect "version-view?version_id=$version_id"
