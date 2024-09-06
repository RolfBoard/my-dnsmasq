#!/usr/bin/awk -f

/cached/ {
    cache_return++
    print "Cache Return:", $0
}
/forwarded/ {
    cache_hit++
    print "Cache Hit:", $0
}
/query/ {
    hostname = $6  
    print "Hostname:", hostname
}

END {
    print "\nSum:"
    print "Total Cache Return:", cache_return
    print "Total Cache Hit:", cache_hit
}

