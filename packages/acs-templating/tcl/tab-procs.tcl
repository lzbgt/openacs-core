####################################
#
# Procs for creating the tabbed UI
#
# The tabs object is basically just a form
# Each tab is a formwidget

# A tab is just a formwidget

proc template::widget::tab { element_reference tag_attributes } {

  upvar $element_reference element

  if { [info exists element(html)] } {
    array set attributes $element(html)
  }

  array set attributes $tag_attributes

  if { !$element(current) } {

    set url $element(base_url)
    if { [string first "?" $url] >= 0 } {
      set joiner "&"
    } else {
      set joiner "?"
    }

    set id $element(form_id)
    set output "<a href=\"${url}${joiner}${id}_tab=$element(name)\">"
    append output "$element(label)</a>"
  } else {  
    append output "<b>$element(label)</b>"
  }

  return $output
}

# The namespace

namespace eval template::tabstrip {}

# Dispatch proc
proc template::tabstrip { command args } {
  eval template::tabstrip::$command $args
}

# Create a new tabbed page
# accepts the -base_url tag

proc template::tabstrip::create { dlg_name args } {

  template::util::get_opts $args

  set code [list template::form create $dlg_name]
 
  # Determine cookie name
  if { [template::util::is_nil opts(cookie_name)] } {
    set cookie_name $dlg_name
  } else {
    set cookie_name $opts(cookie_name)
  }

  lappend code -cookie_name $cookie_name

  eval $code $args

  # Determine the current tab
  set level [template::adp_level]
  upvar #$level $dlg_name:properties form_properties

  # Check parameters
  if { ![template::util::is_nil opts(current_tab)] } {
    set current_tab $opts(current_tab)
  } else {
    # Check http
    set http_tab [ns_queryget "${dlg_name}_tab"]
    if { ![template::util::is_nil http_tab] } {
      set current_tab $http_tab
    } else {
      # Check cookie... Ok, NSV, since cookie doesn't work
      if { [nsv_exists tabstrip_tab $cookie_name] } {
        set cookie_tab [nsv_get tabstrip_tab $cookie_name]
        set current_tab $cookie_tab
      } else {
        # Give up
        set current_tab ""
      }
    }
  }
  
  set_current_tab $dlg_name $current_tab 3

}

# Add a tab
# Valid options are:
# -template_params { name value name value ... }
# -base_url base_url
# any element::create options 

proc template::tabstrip::add_tab { 
  dlg_name name label template args
} {
  # Determine the current tab
  set level [template::adp_level]
  upvar #$level $dlg_name:properties properties

  template::util::get_opts $args

  # Set default params
  set code [list template::element create $dlg_name $name -label "$label"]
  lappend code -datatype text -widget tab -optional 

  # Set tab-specific params

  if { [template::util::is_nil opts(base_url)] } {
    if { ![template::util::is_nil properties(base_url)] } {
      # use global base_url
      lappend code -base_url $properties(base_url)
    } else {
      # use current page
      lappend code -base_url [ns_conn url]
    }
  }  

  lappend code -template $template 

  if { [string equal $properties(current_tab) $name] } {
    lappend code -current 1
  } else {
    lappend code -current 0
  }

  eval "$code $args"

  upvar #$level $dlg_name:$name element

  # If this is the first tab being added, set it as current
  if { [template::util::is_nil properties(current_tab)] } {
    set_current_tab $dlg_name [lindex $properties(element_names) 0] 3
  }

}

proc template::tabstrip::set_current_tab { dlg_name tab_name {rel_level 2}} {
  
  set level [template::adp_level]
  upvar #$level $dlg_name:properties properties 
  upvar #$level $dlg_name:$tab_name element

  set properties(current_tab) $tab_name

  # Set the variable in calling frame(s) so that the ADP can access them
  upvar $rel_level $dlg_name dlg2
  if { [info exists element] } {
    set dlg2(src) $element(template)
    set element(current) 1
  }

  set dlg2(tab) $properties(current_tab)

  # Store the current tab. This should really be a cookie, but I can't
  # set them correctly for some reason.
  nsv_set tabstrip_tab $properties(cookie_name) $tab_name

}

# The tabstrip tag

template_tag tabstrip { chunk params } {

  set level [template::adp_level]

  set id [template::get_attribute formtemplate $params id]

  upvar #$level $id:properties form_properties

  # Create a variable called "plus" that holds the + sign
  # Since the actual + character is regexped out... how lame
  set tabstrip_plus "+"

  template::adp_append_code "set form:id \"$id\""

  # Set optional attributes for the style template
  template::adp_append_code "
    upvar 0 \"$id:properties\" form_properties"

  # Change the default style if no style is specified
  if { [string equal [ns_set iget $params style] ""] } {
    ns_set update $params style tabbed-dialog
  }

  # Render the template
  if { [string equal [string trim $chunk] {}] } {
    # generate the form body dynamically if none specified.
    set style [ns_set iget $params style]
    if { [template::util::is_nil style] } {
      set style "tabbed-dialog"
    }
    template::adp_append_string "\[template::form generate $id $style\]"
  } else {
    # compile the static form layout specified in the template
    template::adp_compile_chunk $chunk
  }

}



