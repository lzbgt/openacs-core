ad_page_contract {

  @author Rafael Schloming (rhs@mit.edu)
  @creation-date 2000-09-09
  @cvs-id $Id$

} {
  new_node_id:naturalnum
  parent_id:integer,notnull
  name:notnull
  node_type:notnull
  {expand:integer,multiple {}}
  {root_id:integer {}}
} -validate {
  name_root_ck -requires name:notnull {
    if {[string match "*/*" $name]} {
      ad_complain
    }
  }

  name_duplicate_ck -requires name_root_ck {
      if { [db_string site_node_duplicate_name_root_ck {
          select decode(count(*), 0, 0, 1) 
          from site_nodes
          where name = :name
          and parent_id = :parent_id
          and node_id <> :new_node_id
      } -default 0]} {
          ad_complain
      }
  }

  node_type_ck -requires node_type:notnull {
      switch $node_type {
          folder {
              set directory_p t
              set pattern_p t
          }

          file {
              set directory_p f
              set pattern_p f
          }
          
          default {
              ad_complain
          }
      }
  }

} -errors {
    name_root_ck {Folder or file names cannot contain '/'}
    name_duplicate_ck {The URL mapping you are creating is already in use.  Please delete the other one or change your URL.}
    node_type_ck {The node type you specified is invalid}
}

set user_id [ad_verify_and_get_user_id]
set ip_address [ad_conn peeraddr]

db_transaction {
    set node_id [db_exec_plsql node_new {
        begin
        :1 := site_node.new (
        node_id => :new_node_id,
        parent_id => :parent_id,
        name => :name,
        directory_p => :directory_p,
        pattern_p => :pattern_p,
        creation_user => :user_id,
        creation_ip => :ip_address
        );
        end;
    }]
} on_error {
    if {![db_string site_node_new_doubleclick_protect {
        select decode(count(*), 0, 0, 1) 
        from site_nodes
        where node_id = :new_node_id
    } -default 0]} {
        ad_return_complaint "Error Creating Site Node" "The following error was generated
                when attempting to create the site node:
        <blockquote><pre>
                [ad_quotehtml $errmsg]
        </pre></blockquote>"
    }
}

if {[lsearch $expand $parent_id] == -1} {
  lappend expand $parent_id
}

ad_returnredirect .?[export_url_vars expand:multiple root_id]
