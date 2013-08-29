ad_page_contract {
} {
}

set page_title "Cache Control"
set context [list [list "../developer" "Developer's Administration"] $page_title]

template::multirow create caches name entries size max flushed hit_rate

foreach cache [lsort -dictionary [ns_cache_names]] {
    if { [ns_info name] eq "AOLserver" } {
        ns_cache_stats $cache stats_array    
    } else {
        array set stats_array [ns_cache_stats $cache]
    }

    set pair [ns_cache_size $cache]
    set size [format "%.2f MB" [expr {[lindex $pair 1] / 1048576.0}]]
    set max [format "%.2f MB" [expr {[lindex $pair 0] / 1048576.0}]]
    set entries $stats_array(entries)
    set flushed $stats_array(flushed)
    set hit_rate $stats_array(hitrate)
    template::multirow append caches $cache $entries $size $max \
        $flushed $hit_rate
}
