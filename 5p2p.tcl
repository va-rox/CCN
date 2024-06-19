# Define options
set ns [new Simulator]
set nf [open out.nam w]
$ns namtrace-all $nf

# Define default values
set queueSize 50
set delay "2ms"
set bw1 "1Mbps"
set bw2 "2Mbps"
set bw3 "3Mbps"
set bw4 "4Mbps"
set bw5 "5Mbps"

# Create five nodes
for {set i 0} {$i < 5} {incr i} {
    set n($i) [$ns node]
}

# Create duplex links between the nodes
$ns duplex-link $n(0) $n(1) $bw1 $delay DropTail
$ns queue-limit $n(0) $n(1) $queueSize

$ns duplex-link $n(1) $n(2) $bw2 $delay DropTail
$ns queue-limit $n(1) $n(2) $queueSize

$ns duplex-link $n(2) $n(3) $bw3 $delay DropTail
$ns queue-limit $n(2) $n(3) $queueSize

$ns duplex-link $n(3) $n(4) $bw4 $delay DropTail
$ns queue-limit $n(3) $n(4) $queueSize

# Set up traffic source and sink
set udp [new Agent/UDP]
$ns attach-agent $n(0) $udp
set null [new Agent/Null]
$ns attach-agent $n(4) $null
$ns connect $udp $null

# Set up a CBR traffic source
set cbr [new Application/Traffic/CBR]
$cbr set packetSize_ 500
$cbr set interval_ 0.005
$cbr attach-agent $udp

# Schedule events for the CBR traffic
$ns at 0.5 "$cbr start"
$ns at 4.5 "$cbr stop"

# Define a finish procedure
proc finish {} {
    global ns nf
    $ns flush-trace
    close $nf
    exec nam out.nam &
    exit 0
}

# Run the simulation
$ns run

