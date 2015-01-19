README  BC-AT-DAO-batch-generation
----------------------------------------------------------

These files are used to transform exported EAD from the Archivist Toolkit into a tab delimited file which is used to create DAOs

There are three steps to the process.

CREATE IMPORT FILE FOR TOOLKIT
--------------------------------------------------------
All three files are REQUIRED for the transformation:

1) at-dao-tab-delimited-export.xsl  -> XSL stylesheet to process EAD XML to tab delimited import file.

2) atDAOInstanceTypeLookup.xml -> XML document used by at-dao-tab-delimited-export.xsl  to map AT Instance Type to mods:typeOfResource.
    Also used to create language code field.
    Any changes to the AT Instance types lookup list will need to be reflected in this document.
    
3) headerDefault.xml -> XML document containing column headers for tab delimited import file.
    The file will not import if this is missing or unavailable.

All three files need to be located in the same local directory.


ADD COMPONENT ROWS TO TAB DELIMITED FILE
-------------------------------------------------------------
Component rows must be added to each parent record.  

1.) addComponents.pl -> Input files are tab (1) import file and (2) a text file containing the file names for each component.
	directory structure is omitted from text file containing file names

Usage: addComponents.pl tabimportfile componentsfile

STRIP EXTRA QUOTES FROM TAB FILE
-------------------------------------------------------------
After the tab import file has been updated by scanners, it must be stripped of extra quotes.

1) stripQuotes.pl -> Script to strip extra quotes. Input file is tab workflow document. Output is new file named new_inputfilename.

Usage: stripQuotes.pl tabimportfile



LINK  DAO TO RESOURCE RECORD
-------------------------------------------------------
Imported DAOs must be linked to parent Resource

All three files are REQUIRED:

1) linkATDAO.pl -> Script that will connect to the Toolkit database and link DAO to Resource

2) linkATDAO.config -> Config file used by linkATDAO.pl. This needs to be edited to reflect actual database settings.

3) Tab delimited file from Step 2

Usage: linkATDAO.pl tabfile





