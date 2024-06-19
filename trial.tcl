set ns [new Simulator]

set nf [open trial.nam w]
$ns namtrace-all $nf

set tf [open trial.tr w]
$ns trace-all $tf

proc finish {} {
	global ns nf tf
	$ns flush-trace
	close $nf
	close $tf
	exec nam trial.nam &
	exit 0
}


set n0 [$ns node]
$n0 color "magenta"
$n0 shape square
set n1 [$ns node]
$n1 color "red"
#$n1 shape triangle 		any shape apart from square and circle (default) doesnt work
set n2 [$ns node]
$n2 color "blue"
#$n2 shape pentagon
set n3 [$ns node]
$n3 color "green"
#$n3 shape hexagon

$ns duplex-link $n0 $n1 10Mb 10ms DropTail
$ns duplex-link $n1 $n2 10Mb 10ms DropTail
$ns duplex-link $n2 $n3 10Mb 10ms DropTail
$ns duplex-link $n3 $n0 10Mb 10ms DropTail

$ns duplex-link-op $n0 $n1 orient right
$ns duplex-link-op $n1 $n2 orient down
$ns duplex-link-op $n2 $n3 orient left
$ns duplex-link-op $n3 $n0 orient up


set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0

set sink0 [new Agent/TCPSink]
$ns attach-agent $n2 $sink0

$ns connect $tcp0 $sink0


set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0

$ns at 1.0 "$ftp0 start"
$ns at 5.0 "$ftp0 stop"

$ns at 10 "finish"
$ns run
