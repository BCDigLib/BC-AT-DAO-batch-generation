README  BC-AT-DAO-batch-generation
----------------------------------------------------------

These files are used to transform exported EAD from the Archivist Toolkit into a tab delimited file which is used to create DAOs

All three files are REQUIRED for the transformation:

1) at-dao-tab-delimited-export.xsl  -> XSL stylesheet to process EAD XML to tab delimited import file.

2) atDAOInstanceTypeLookup.xml -> XML document used by at-dao-tab-delimited-export.xsl  to map AT Instance Type to mods:typeOfResource.
    Also used to create language code field.
    Any changes to the AT Instance types lookup list will need to be reflected in this document.
    
3) headerDefault.xml -> XML document containing column headers for tab delimited import file.
    The file will not import if this is missing or unavailable.

All three files need to be located in the same local directory.