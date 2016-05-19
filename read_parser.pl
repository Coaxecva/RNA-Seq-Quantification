# (1) quit unless we have the correct number of command-line args
$num_args = $#ARGV + 1;
if ($num_args != 2) {
    print "\nUsage: read_paser.pl read.fasta read.txt\n";
    exit;
}
 
system("sed 's/;mate.*//' $ARGV[0] | sed 's/read.*[/]//' > $ARGV[1]");

print "Hello, process has done\n";
