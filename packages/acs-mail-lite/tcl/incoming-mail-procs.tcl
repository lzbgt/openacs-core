ad_library {

    Provides a simple API for reliably sending email.
    
    @author Eric Lorenzo (eric@openforce.net)
    @creation-date 22 March 2002
    @cvs-id $Id$

}

package require mime 1.4
package require smtp 1.4
package require base64 2.3.1
namespace eval acs_mail_lite {

    #---------------------------------------
    ad_proc -private load_mails {
        -queue_dir:required
    } {
        Scans for incoming email. You need

        An incoming email has to comply to the following syntax rule:
        [<SitePrefix>][-]<ReplyPrefix>-Whatever@<BounceDomain>

        [] = optional
        <> = Package Parameters

        If no SitePrefix is set we assume that there is only one OpenACS installation. Otherwise
        only messages are dealt with which contain a SitePrefix.

        ReplyPrefixes are provided by packages that implement the callback acs_mail_lite::incoming_email
        and provide a package parameter called ReplyPrefix. Only implementations are considered where the
        implementation name is equal to the package key of the package.

        Also we only deal with messages that contain a valid and registered ReplyPrefix.
        These prefixes are automatically set in the acs_mail_lite_prefixes table.

        @author Nima Mazloumi (nima.mazloumi@gmx.de)
        @creation-date 2005-07-15

        @option queue_dir The location of the qmail mail (BounceMailDir) queue in the file-system i.e. /home/service0/mail.

        @see acs_mail_lite::incoming_email
        @see acs_mail_lite::parse_email
    } {
       
        # get list of all incoming mail
        if {[catch {
            set messages [glob "$queue_dir/new/*"]
        } errmsg]} {
            if {[string match "no files matched glob pattern*"  $errmsg ]} {
                ns_log Debug "load_mails: queue dir = $queue_dir/new/*, no messages"
            } else {
                ns_log Error "load_mails: queue dir = $queue_dir/new/ error $errmsg"
            }
            return [list]
        }

        # loop over every incoming mail
	foreach msg $messages {
	    ns_log Debug "load_mails: opening $msg"
	    array set email {}
	    
	    parse_email -file $msg -array email
 	    set email(to) [parse_email_address -email $email(to)]
 	    set email(from) [parse_email_address -email $email(from)]

	    # Special treatment for e-mails which look like they contain an object_id
	    set callback_executed_p 0
	    set pot_object_id [lindex [split $email(to) "@"] 0]
	    if {[ad_var_type_check_number_p $pot_object_id]} {
		if {[acs_object::object_p -id $pot_object_id]} {
		    callback acs_mail_lite::incoming_object_email -array email -object_id $pot_object_id

		    # Mark that the callback has been executed already
		    set callback_executed_p 1
		}
	    }
	    
	    if {!$callback_executed_p} {
		# We execute all callbacks now
		callback acs_mail_lite::incoming_email -array email
	    }

            #let's delete the file now
            if {[catch {ns_unlink $msg} errmsg]} {
                ns_log Error "load_mails: unable to delete queued message $msg: $errmsg"
            } else {
		ns_log Debug "load_mails: deleted $msg"
	    }
        }
    }

    #---------------------------------------
    ad_proc parse_email {
	-file:required
	-array:required
    } {
	An email is splitted into several parts: headers, bodies and files lists and all headers directly.
	
	The headers consists of a list with header names as keys and their correponding values. All keys are lower case.
	The bodies consists of a list with two elements: content-type and content.
	The files consists of a list with three elements: content-type, filename and content.
	
	The array with all the above data is upvared to the caller environment.

	Important headers are:
	
	-message-id (a unique id for the email, is different for each email except it was bounced from a mailer deamon)
	-subject
	-from
	-to
	
	Others possible headers:
	
	-date
	-received
        -references (this references the original message id if the email is a reply)
	-in-reply-to (this references the original message id if the email is a reply)
	-return-path (this is used for mailer deamons to bounce emails back like bounce-user_id-signature-package_id@service0.com)
	
	Optional application specific stuff only exist in special cases:
	
	X-Mozilla-Status
	X-Virus-Scanned
	X-Mozilla-Status2
	X-UIDL
	X-Account-Key
	X-Sasl-enc
	
	You can therefore get a value for a header either through iterating the headers list or simply by calling i.e. "set message_id $email(message-id)".
	
	Note: We assume "application/octet-stream" for all attachments and "base64" for
	as transfer encoding for all files.
	
	Note: tcllib required - mime, base64
	
	@author Nima Mazloumi (nima.mazloumi@gmx.de)
	@creation-date 2005-07-15
	
    } {
	upvar $array email

	#prepare the message
	if {[catch {set mime [mime::initialize -file $file]} errormsg]} {
	    ns_log error "Email could not be delivered for file $file"
	    set stream [open $file]
	    set content [read $stream]
	    close $stream
	    ns_log error "$content"
	    ns_unlink $file
	    return
	}
	
	#get the content type
	set content [mime::getproperty $mime content]
	
	#get all available headers
	set keys [mime::getheader $mime -names]
		
	set headers [list]

	# create both the headers array and all headers directly for the email array
	foreach header $keys {
	    set value [mime::getheader $mime $header]
	    set email([string tolower $header]) $value
	    lappend headers [list $header $value]
	}

	set email(headers) $headers
		
	#check for multipart, otherwise we only have one part
	if { [string first "multipart" $content] != -1 } {
	    set parts [mime::getproperty $mime parts]
	} else {
	    set parts [list $mime]
	}
	
	# travers the tree and extract parts into a flat list
	set all_parts [list]
	foreach part $parts {
	    if {[mime::getproperty $part content] eq "multipart/alternative"} {
		foreach child_part [mime::getproperty $part parts] {
		    lappend all_parts $child_part
		}
	    } else {
		lappend all_parts $part
	    }
	}
	
	set bodies [list]
	set files [list]
	
	#now extract all parts (bodies/files) and fill the email array
	foreach part $all_parts {

	    # Attachments have a "Content-disposition" part
	    # Therefore we filter out if it is an attachment here
	    if {[catch {mime::getheader $part Content-disposition}]} {
		switch [mime::getproperty $part content] {
		    "text/plain" {
			lappend bodies [list "text/plain" [mime::getbody $part]]
		    }
		    "text/html" {
			lappend bodies [list "text/html" [mime::getbody $part]]
		    }
		}
	    } else {
		set encoding [mime::getproperty $part encoding]
		set body [mime::getbody $part -decode]
		set content  $body
		set params [mime::getproperty $part params]
		if {[lindex $params 0] eq "name"} {
		    set filename [lindex $params 1]
		} else {
		    set filename ""
		}

		# Determine the content_type
		set content_type [mime::getproperty $part content]
		if {$content_type eq "application/octet-stream"} {
		    set content_type [ns_guesstype $filename]
		}

		lappend files [list $content_type $encoding $filename $content]
	    }
	}

	set email(bodies) $bodies
	set email(files) $files
	
	#release the message
	mime::finalize $mime -subordinates all
    }    
        
}