#!/usr/local/bin/perl -w
# Test for File::Temp - tempfile function

use strict;
use Test;
BEGIN { plan tests => 11}
use File::Spec;

# Will need to check that all files were unlinked correctly
# Set up an END block here to do it 

my (@files, @dirs); # Array containing list of dirs/files to test

# Loop over an array hoping that the files dont exist
END { foreach (@files) { ok( !(-e $_) )} }

# And a test for directories
END { foreach (@dirs) { ok( !(-d $_) )} } 

# Need to make sure that the END blocks are setup before
# the ones that File::Temp configures since END blocks are evaluated
# in revers order and we need to check the files *after* File::Temp
# removes them
use File::Temp qw/ tempfile tempdir/;

# Now we start the tests properly
ok(1);


# Tempfile
# Open tempfile in some directory, unlink at end
my ($fh, $tempfile) = tempfile(
			       UNLINK => 1,
			       SUFFIX => '.txt',
			      );

ok( (-f $tempfile) );
push(@files, $tempfile);

# TEMPDIR test
# Create temp directory in current dir
my $template = 'tmpdirXXXXXX';
print "# Template: $template\n";
my $tempdir = tempdir( $template ,
		       DIR => File::Spec->curdir,
		       CLEANUP => 1,
		     );

print "# TEMPDIR: $tempdir\n";

ok( (-d $tempdir) );
push(@dirs, $tempdir);

# Create file in the temp dir
($fh, $tempfile) = tempfile(
			    DIR => $tempdir,
			    UNLINK => 1,
			    SUFFIX => '.dat',
			   );

print "# TEMPFILE: Created $tempfile\n";

ok( (-f $tempfile));
push(@files, $tempfile);

# Test tempfile
# ..and again
($fh, $tempfile) = tempfile(
			    DIR => $tempdir,
			   );


ok( (-f $tempfile ));
push(@files, $tempfile);

print "# TEMPFILE: Created $tempfile\n";

# and another (with template)

($fh, $tempfile) = tempfile( 'helloXXXXXXX',
			    DIR => $tempdir,
			    UNLINK => 1,
			    SUFFIX => '.dat',
			   );

print "# TEMPFILE: Created $tempfile\n";

ok( (-f $tempfile) );
push(@files, $tempfile);

# no tests yet to make sure that the END{} blocks correctly remove
# the files
