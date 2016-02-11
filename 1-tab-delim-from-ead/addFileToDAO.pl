#!/usr/bin/perl -w
   
use strict;
use FileHandle;
use Getopt::Long;
use DBI;
use Switch;
my %opts = ();
my %sqlStrings;
my $debugFH;

main();

#-----------------------------------------------------------------------------
sub main {
    
	usage()
		if !(@ARGV);
	
	my ($fileExists, $fileAdd, $debug) = @ARGV;

	my $useStatement;
	
	switch ($fileAdd) {
		case 'jpg' { $useStatement = 'reference image'}
		case 'tif' { $useStatement = 'archive image'}		
	}
	
	# Initialize settings from config file
	initSettings();
	
	# Initialize SQL strings
	initSQL();
    
	my $logFH = new FileHandle;
	my $logFile = $fileExists . "_manifestation.log";
	$logFH->open("> $logFile");
		
	if ($debug) {
		# setting debug value will cause script to log SQL statements and not update DB
		$debugFH = new FileHandle;
		my $debugFile = $fileExists . "_debug.log";
		$debugFH->open("> $debugFile");	
	}
	
	my $fileExistsFH = new FileHandle;
	
	$fileExistsFH->open($fileExists)
		or die("\n\nERROR: Unable to open tab file -> $fileExists\n\n");
	
	my $dbh = DBI->connect('dbi:mysql:database='.$opts{database} . ';host=' . $opts{hostname}. ';port=3306',$opts{user},$opts{password},{AutoCommit => 1, RaiseError => 1})
		or die "Connection Error: $DBI::errstr\n";
	
	my $sth = $dbh->prepare(qq{$sqlStrings{'getSYSDATE'}});
	$sth->execute();
	my $sysdate  = $sth->fetchrow_array;
	my $user = 'daolink';
	
	#Read filenames that have been loaded - use same filename input file that was used by addComponents.pl
	while(not($fileExistsFH->eof)) {
		my $lineIn = $fileExistsFH->getline;
		chomp $lineIn;
		
		my $componentId = $lineIn;
		$componentId =~ s/\.(\w{3})$//;
		my $newManifestation = $componentId . "." . $fileAdd;
		
		# First step: Get digitalObjectId for already loaded manifestation
		$sth = $dbh->prepare(qq{$sqlStrings{'getdigitalObjectId'}});
		$sth->execute($lineIn);
		
		my $digitalObjectId  = $sth->fetchrow_array;
		
		$sth = $dbh->prepare(qq{$sqlStrings{'updateDAO'}});
				
		if ($debug) {
			print "Adding $sysdate $sysdate $user $user $newManifestation $useStatement 1 $digitalObjectId\n";
			print $debugFH "Inserting $lineIn  digitalObjectId is $digitalObjectId\n";
			print $debugFH "Adding $sysdate $sysdate $user $user $newManifestation $useStatement 1 $digitalObjectId\n";
			
		} else {
			print "Adding $sysdate $sysdate $user $user $newManifestation $useStatement 1 $digitalObjectId\n";
			print $logFH "Adding $sysdate $sysdate $user $user $newManifestation $useStatement 1 $digitalObjectId\n";
			$sth->execute($sysdate, $sysdate, $user, $user, $newManifestation, $useStatement, $digitalObjectId);
			print "DONE\n";
		}
		
		# Pause
		sleep(1);
	}    
	
	$debugFH->close()
		if ($debug);
		
	print "\n\nSuccess\n";
}

#-----------------------------------------------------------------------------
sub initSettings {
        
    GetOptions ("hostname=s"	=> \$opts{hostname},
                "user=s"       			=> \$opts{user},
		"password=s"       		=> \$opts{password},
		"database=s"       		=> \$opts{database});
	
    my $config = 'addFileToDAO.config';							

    # read settings from config
    my $configFH = new FileHandle;
	
    $configFH->open($config);
    while(not($configFH->eof)) {
        my $lineIn = $configFH->getline;
        chomp $lineIn;
	# skip comments
	unless ( $lineIn =~ /^#/ ) {
	    $lineIn =~ /(.+)\=(.+)/;
	    my ($key, $value) = ($1, $2);
	    $value =~ s/^\s//;
	    $key =~ s/\s//g;
	    $opts{$key} = $value;		    
	}
    }
    
    $configFH->close();
}

#-----------------------------------------------------------------------------
sub initSQL {
	
	$sqlStrings{'getdigitalObjectId'} =
	"SELECT digitalObjectId FROM FileVersions WHERE uri = ? AND sequenceNumber = '0'";
		
	$sqlStrings{'updateDAO'} =
	"INSERT INTO FileVersions(lastUpdated, created, lastUpdatedBy, createdBy, uri, useStatement, sequenceNumber,digitalObjectId) VALUES
	(?, ?, ?, ?, ?, ?, '1',?)";

	$sqlStrings{'getSYSDATE'} =
	"SELECT SYSDATE()";
}

#-----------------------------------------------------------------------------
sub usage {
	
	print "\n\n-----------------------------------------------------------------\n";
	print "Usage: addFileToDAO.pl existingfiles fileextenstion\n\n";
	print "Where existing files is list of filenames already loaded (addComponents.pl input). \nfileextenstion is extension of new manifestation to add\n";
	exit 1;
}
#-----------------------------------------------------------------------------
 
