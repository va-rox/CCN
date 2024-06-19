# Define a procedure to set up the simulation and measure packet drops
proc run_simulation {bw} {
    set ns [new Simulator]

    # Create trace file
    set tf [open out.tr w]
    $ns trace-all $tf

    # Create NAM trace file
    set nf [open out.nam w]
    $ns namtrace-all $nf
    global ns nf tf
    # Define nodes
    set n0 [$ns node]
    set n1 [$ns node]
    set n2 [$ns node]
    set n3 [$ns node]
    set n4 [$ns node]

    # Define queue size
    set queueSize 10

    # Create duplex links with variable bandwidth and fixed delay
    set delay 10ms
    $ns duplex-link $n0 $n1 $bw $delay DropTail
    $ns duplex-link $n1 $n2 $bw $delay DropTail
    $ns duplex-link $n2 $n3 $bw $delay DropTail
    $ns duplex-link $n3 $n4 $bw $delay DropTail
    $ns duplex-link $n4 $n0 $bw $delay DropTail

    # Set queue size for each link
    $ns queue-limit $n0 $n1 $queueSize
    $ns queue-limit $n1 $n2 $queueSize
    $ns queue-limit $n2 $n3 $queueSize
    $ns queue-limit $n3 $n4 $queueSize
    $ns queue-limit $n4 $n0 $queueSize

    # Create a UDP agent and attach it to node n0
    set udp0 [new Agent/UDP]
    $ns attach-agent $n0 $udp0

    # Create a CBR traffic source and attach it to UDP agent
    set cbr0 [new Application/Traffic/CBR]
    $cbr0 set packetSize_ 500
    $cbr0 set interval_ 0.01
    $cbr0 attach-agent $udp0

    # Create a Null agent (traffic sink) and attach it to node n4
    set null0 [new Agent/Null]
    $ns attach-agent $n4 $null0

    # Connect the traffic source to the sink
    $ns connect $udp0 $null0

    # Schedule the CBR traffic
    $ns at 0.5 "$cbr0 start"
    $ns at 4.5 "$cbr0 stop"

    # Define a finish procedure
    proc finish {} {
        # Define a procedure to set up the simulation and measure packet drops
    set ns [new Simulator]

    # Create trace file
    set tracefile [open out.tr w]
    $ns trace-all $tracefile

    # Define nodes
    set n0 [$ns node]
    set n1 [$ns node]
    set n2 [$ns node]
    set n3 [$ns node]
    set n4 [$ns node]

    # Define queue size
    set queueSize 10

    # Create duplex links with variable bandwidth and fixed delay
    set delay 10ms
    $ns duplex-link $n0 $n1 $bw $delay DropTail
    $ns duplex-link $n1 $n2 $bw $delay DropTail
    $ns duplex-link $n2 $n3 $bw $delay DropTail
    $ns duplex-link $n3 $n4 $bw $delay DropTail
    $ns duplex-link $n4 $n0 $bw $delay DropTail

    # Set queue size for each link
    $ns queue-limit $n0 $n1 $queueSize
    $ns queue-limit $n1 $n2 $queueSize
    $ns queue-limit $n2 $n3 $queueSize
    $ns queue-limit $n3 $n4 $queueSize
    $ns queue-limit $n4 $n0 $queueSize

    # Create a UDP agent and attach it to node n0
    set udp0 [new Agent/UDP]
    $ns attach-agent $n0 $udp0

    # Create a CBR traffic source and attach it to UDP agent
    set cbr0 [new Application/Traffic/CBR]
    $cbr0 set packetSize_ 500
    $cbr0 set interval_ 0.01
    $cbr0 attach-agent $udp0

    # Create a Null agent (traffic sink) and attach it to node n4
    set null0 [new Agent/Null]
    $ns attach-agent $n4 $null0

    # Connect the traffic source to the sink
    $ns connect $udp0 $null0

    # Schedule the CBR traffic
   
        $ns flush-trace
        close $tf
        close $nf
        exec awk '{if ($1=="d") drop++} END {print "Dropped Packets:", drop}' out.tr
        exec nam out.nam &
        exit 0


    # Schedule the finish procedure
    $ns at 5.0 "finish"

    # Run the simulation
    $ns run
}

# Run the simulation with different bandwidth values
foreach bw {0.5Mb 1Mb 2Mb 5Mb} {
    puts "Running simulation with bandwidth $bw..."
    run_simulation {$bw}
}

