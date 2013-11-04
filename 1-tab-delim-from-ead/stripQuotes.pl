#!/usr/bin/perl -w
   
use strict;
use FileHandle;

main();

#-----------------------------------------------------------------------------
sub main {
    
    	die "\n\nUsage: stripQuotes.pl tabimportfile\n\n"
		if !(@ARGV);
		
	my $infile = shift @ARGV;
	
	my $oldFH = new FileHandle;
	my $newFH = new FileHandle;
	
	$oldFH->open($infile);
	my $newfile = "new_".$infile;
	
	die "WARNING: $newfile already exists\n"
		if (-e $newfile);
		
	$newFH->open("> $newfile");
	
	while(not($oldFH->eof)) {
		
		my $lineIn = $oldFH->getline;	
		
		if ($lineIn =~ /FALSE/) {
			$lineIn =~ s/""/"/g;
		}
		
		print $newFH $lineIn;
		
	} 	
}


