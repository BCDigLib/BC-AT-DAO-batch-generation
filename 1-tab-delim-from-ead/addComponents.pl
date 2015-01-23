#!/usr/bin/perl -w
   
use strict;
use FileHandle;
use File::Slurp;


main();

#-----------------------------------------------------------------------------
sub main {
    
    	die "\n\nUsage: addComponents.pl tabimportfile componentsfile\n\n"
		if (!(@ARGV) || (scalar(@ARGV)<2));
		
	my $tabImportFile = shift @ARGV;
	my $componentsFile = shift @ARGV;
	
	my $oldFH = new FileHandle;
	my $newFH = new FileHandle;

	my @component = read_file($componentsFile);
	
	$oldFH->open($tabImportFile);
	my $newfile = "new_".$tabImportFile;
	
	die "WARNING: $newfile already exists\n"
		if (-e $newfile);
		
	$newFH->open("> $newfile");

	while(not($oldFH->eof)) {
		
		my $lineIn = $oldFH->getline;	
		my @parentRow;

		if ($lineIn !~ /FALSE/) {print $newFH $lineIn;} #print the header row	
		else 	#enhance and print parent row
		{	
			@parentRow = split('\t', $lineIn);			
			$parentRow[22] = 'reformatted digital';  #assumes digitized originals
			$parentRow[30] = 'image/jpeg'; 	#assumes only one mime type for project
									#if there are multiple mime types, they  															#should be delimited by semicolons	
			$lineIn = join("\t", @parentRow);
			print $newFH $lineIn;
			
			my $count = 0;
			foreach (@component)
			#enhance and print component rows
			{
				chomp;
	
				my $prefix = $_;
				$prefix =~ s/_\d*\..*$//;
				my $componentID = $prefix;
				my @componentRow = (('') x 20);					
		
				if ($componentID eq $parentRow[3])
				{
						$componentRow[1]=$parentRow[1];
						$componentRow[2]="TRUE";
						$count++;
						$componentRow[3] = $count;
						my $label = $_;
						$label =~ s/\..*$//;
						$componentRow[7] = $label;
						$componentRow[14] = $_;
						$componentRow[15] = "reference image";  #assumption
						
						print $newFH join("\t", @componentRow)."\n";

				}
			}
		}

	} 	
}

=pod
Usage: addComponents.pl tabimportfile componentsfile

Takes a tab delimited export file generated from EAD and adds component rows. 

tabimportfile is generated in a previous step by running an xlst an an exported EAD

components file is a list of the component file names.  The file must contain file names only, no paths or other information.

Certain assumptions are made about iana mime types, usage, and digital origin.  The default values in this script should be reviewed and updated on a project basis.

=cut
