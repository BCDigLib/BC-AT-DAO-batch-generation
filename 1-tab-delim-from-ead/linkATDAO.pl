#!/usr/bin/perl -w
   
use strict;
use FileHandle;
use Getopt::Long;
use DBI;
use Math::Round;
my %opts = ();
my %daoLookup;
my %sqlStrings;

main();

#-----------------------------------------------------------------------------
sub main {
    
	usage()
		if !(@ARGV);
	
	my $tabfile = shift @ARGV;							

	# Initialize settings from config file
	initSettings();
	
	# Initialize SQL strings
	initSQL();
    
	#Read tab delimited input file - created by at-dao-tab-delimited-export.xsl
	readTab($tabfile);
	
	my $dbh = DBI->connect('dbi:mysql:database='.$opts{database} . ';host=' . $opts{hostname}. ';port=3306',$opts{user},$opts{password},{AutoCommit => 1, RaiseError => 1})
		or die "Connection Error: $DBI::errstr\n";
		
	# First step: Get session value for archDescriptionInstancesId. Set value high enough to avoid conflit with any open AT client sessions
	my $sth = $dbh->prepare(qq{$sqlStrings{'getarchDescriptionInstancesId'}});
	$sth->execute();
		
	my $archDescriptionInstancesId  = $sth->fetchrow_array;
	$archDescriptionInstancesId = int($archDescriptionInstancesId/1000+1)*1000;
		
	# Iterate over daoLookup hash - each key is componentID	
	for my $componentID ( keys %daoLookup ) {

		# Second step: Get value to insert into ArchDescriptionInstances.resourceComponentId
		$sth = $dbh->prepare(qq{$sqlStrings{'getresourceComponentId'}});
		$sth->execute($componentID);

		if ($sth->rows > 1) { # Something is wrong - should have one result
			print "WARNING: Multiple resourceComponentId matches returned for componentID = $componentID\n";
			print "Skipping. NO objects will be linked for this componentID\n\n";
			next;
		}
		
		my $resourceComponentId = $sth->fetchrow_array;
		
		# Third step: Get value to insert into ArchDescriptionInstances.parentResourceId
		my ($resourceIdentifier1, $resourceIdentifier2, $resourceIdentifier3) =
				($daoLookup{$componentID}{'resourceIdentifier1'},
				 $daoLookup{$componentID}{'resourceIdentifier2'},
				 $daoLookup{$componentID}{'resourceIdentifier3'});
				
		$sth = $dbh->prepare(qq{$sqlStrings{'getresourceId'}});
		$sth->execute($resourceIdentifier1, $resourceIdentifier2, $resourceIdentifier3);
		
		if ($sth->rows > 1) { # Something is wrong - should have one result
			print "WARNING: Multiple parentResourceId matches returned for componentID = $componentID\n";
			print "Skipping. NO objects will be linked for this componentID\n\n";
			next;
		}
				
		my $parentResourceId  = $sth->fetchrow_array;
		
		# Fourth step: Insert new row into ArchDescriptionInstances
		$archDescriptionInstancesId++;
		
		$sth = $dbh->prepare(qq{$sqlStrings{'insertarchDescriptionInstancesId'}});
		$sth->execute($archDescriptionInstancesId,$resourceComponentId,$parentResourceId);

		# Fifth step: Update DigitalObjects
		# digitalObjectId is column in tab import which equals metsIdentifier  value in the digitalobjects table
		# use tab value for query, but digitalObjectId column in digitalobjects table for next update string
		
		my $metsID = $daoLookup{$componentID}{'digitalObjectID'};
		$sth = $dbh->prepare(qq{$sqlStrings{'getDigitalObjectsVersion'}});
		$sth->execute($metsID);

		my ($digitalObjectId, $version)  = $sth->fetchrow_array;
		$version++;
		my $user = 'daolink';
		
		$sth = $dbh->prepare(qq{$sqlStrings{'getSYSDATE'}});
		$sth->execute();
		my $sysdate  = $sth->fetchrow_array;
				
		$sth = $dbh->prepare(qq{$sqlStrings{'updateDigitalObjects'}});	
		$sth->execute($version, $sysdate, $user, $archDescriptionInstancesId, $digitalObjectId);
		
	}
    
	print "Success\n";
}

#-----------------------------------------------------------------------------
sub initSettings {
        
    GetOptions ("hostname=s"	=> \$opts{hostname},
                "user=s"       			=> \$opts{user},
		"password=s"       		=> \$opts{password},
		"database=s"       		=> \$opts{database});
	
    my $config = 'linkATDAO.config';							

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
sub readTab {
	
	my $tabfile = shift;

	my $tabFH = new FileHandle;
	
	$tabFH->open($tabfile)
		or die("\n\nERROR: Unable to open tab file -> $tabfile\n\n");
	
	my $check;
	my ($Container, $digitalObjectID, $isComponent, $componentID, $rest);
	
	while(not($tabFH->eof)) {
		my $lineIn = $tabFH->getline;
		chomp $lineIn;
		if ($lineIn =~ /^Container/) { # Skip header line, but check if file contains Container column
			print "Skipping column header from tab import file\n\n";
			$check =1; # boolean check - split line differently if added column not present
		}	
		if ($check) {
			($Container, $digitalObjectID, $isComponent, $componentID, $rest) = split(/\t/, $lineIn, 5);
		} else {
			($digitalObjectID, $isComponent, $componentID, $rest) = split(/\t/, $lineIn, 4);
		}
		if ($isComponent eq 'FALSE') {
			
			$componentID =~ /(\w+)(\d{4})_(\d+)/;
			
			$daoLookup{$componentID} = {
						'resourceIdentifier1' => $1,
						'resourceIdentifier2' => $2,
						'resourceIdentifier3' => $3,
						'digitalObjectID' => $digitalObjectID
			}
		}
	}
}
 
#-----------------------------------------------------------------------------
sub initSQL {
		
	$sqlStrings{'getresourceComponentId'} =
	"SELECT resourceComponentId FROM ResourcesComponents WHERE ResourcesComponents.subdivisionIdentifier = ?";
	
	$sqlStrings{'getresourceId'} = 
	"SELECT resourceId FROM Resources WHERE resourceIdentifier1 = ? AND resourceIdentifier2 = ? AND resourceIdentifier3 = ?";

	$sqlStrings{'getarchDescriptionInstancesId'} = 
	"SELECT MAX(archDescriptionInstancesId) FROM ArchDescriptionInstances";
	
	$sqlStrings{'insertarchDescriptionInstancesId'} =
	"INSERT INTO ArchDescriptionInstances (archDescriptionInstancesId, instanceDescriminator, instanceType, resourceComponentId, parentResourceId) VALUES
	(?, 'digital', 'Digital Object', ?, ?)";
	
	$sqlStrings{'getDigitalObjectsVersion'} =
	"SELECT digitalObjectId,version  FROM DigitalObjects WHERE metsIdentifier = ? AND parentDigitalObjectId IS NULL";
	
	$sqlStrings{'getSYSDATE'} =
	"SELECT SYSDATE()";
	
	$sqlStrings{'updateDigitalObjects'} = 
	"UPDATE DigitalObjects SET version = ?, lastUpdated = ?, lastUpdatedBy = ?, archDescriptionInstancesId = ? WHERE digitalObjectId = ?";

}

#-----------------------------------------------------------------------------
sub usage {
	
	print "\n\n-----------------------------------------------------------------\n";
	print "Usage: linkATDAO.pl tabfile\n\n";
	print "Where tabfile is tab delimited DAO file\n";
	exit 1;
}
#-----------------------------------------------------------------------------

