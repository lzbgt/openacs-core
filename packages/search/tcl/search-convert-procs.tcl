ad_library {
    Binaries conversion procedures for the search package.
    Thanks to Carsten Clasohm for suggesting the converter programs.

    @author Dirk Gomez <openacs@dirkgomez.de>
    @creation-date 2005-06-25
    @cvs-id $Id$
}


namespace eval search {}
namespace eval search::convert {}

ad_proc -public search::convert::binary_to_text {
    {-filename:required}
    {-mime_type:required}
} {
    Converts the binary file to text and returns this as a string.
    (Carsten Clasohm provided the converters.)

    @author Dirk Gomez <openacs@dirkgomez.de>
    @creation-date 2005-06-25
} {

    set tmp_filename [ns_tmpnam]
    set result ""

    switch $mime_type {
	{application/msword} -
	{application/vnd.ms-word} {
	    set convert_command {/usr/local/bin/catdoc $filename >$tmp_filename}
	}
	{application/powerpoint} {
	    set convert_command {strings $filename >$tmp_filename}
	}
	{application/msexcel} {
	    set convert_command {/usr/local/bin/xls2csv $filename >$tmp_filename}
	}
	{application/pdf} {
	    set convert_command {/usr/local/bin/pdftotext $filename $tmp_filename}
	}
	{text/html} {
	    return [catch {[ns_striphtml $filename]} error]
	}
	default {
	    # If there's nothing implemented for a particular mime type
            # we'll just index filename and pathname
            return ""
	}
    }

    if {[catch {eval exec $convert_command} err]} {
	catch {file delete $tmp_filename}
	puts "DIRK conversion failed - $convert_command: $err"
	file delete $tmp_filename
	return
    }

    set fd [open $tmp_filename "r"]
    set result [read $fd]
    close $fd
    file delete $tmp_filename
    return $result
}

