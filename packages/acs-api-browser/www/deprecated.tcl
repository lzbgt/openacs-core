ad_page_contract {

    returns a list of all the deprecated procedures present 
    in server memory


    @author Todd Nightingale
    @date 2000-7-14
    @cvs $Id$

} {
} -properties {
    title:onevalue
    context_bar:onevalue
    deprecated:multirow
}

set title "Deprecated Procedure Search"
set context_bar [ad_context_bar "Deprecated Procedures"]

multirow create deprecated proc args

foreach proc [nsv_array names api_proc_doc] { 
    array set doc_elements [nsv_get api_proc_doc $proc]
 
    if {$doc_elements(deprecated_p) == 1} {
        multirow append deprecated $proc $doc_elements(positionals)
    } 
}

