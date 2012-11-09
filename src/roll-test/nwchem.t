#!/usr/bin/perl -w
# nwchem roll installation test.  Usage:
# nwchem.t [nodetype]
#   where nodetype is one of "Compute", "Dbnode", "Frontend" or "Login"
#   if not specified, the test assumes either Compute or Frontend

use Test::More qw(no_plan);

my $appliance = $#ARGV >= 0 ? $ARGV[0] :
                -d '/export/rocks/install' ? 'Frontend' : 'Compute';
my $installedOnAppliancesPattern = '.';
my $isInstalled = -d '/opt/nwchem';
my $output;

my $TESTFILE = 'tmpnwchem';

#
# Example from http://www.psc.edu/general/software/packages/nwchem/examples
#
open(OUT, ">$TESTFILE.nwchem");
print OUT <<END;
title "S2 local basis DFT"
memory 100 mb
start s2
geometry
  S 0.0 0.0 0.0
  S 0.0 0.0 1.95
end
basis
S library "6-31G*"
end
task scf
END
close(OUT);

# nwchem-common.xml
if($appliance =~ /$installedOnAppliancesPattern/) {
  ok($isInstalled, 'nwchem installed');
} else {
  ok(! $isInstalled, 'nwchem not installed');
}
SKIP: {

  skip 'nwchem not installed', 4 if ! $isInstalled;
  if(! -f "$ENV{HOME}/.nwchemrc") {
    `ln -s /opt/nwchem/.nwchemrc $ENV{HOME}`;
  }
  $output = `mpirun -np 4 /opt/nwchem/bin/nwchem $TESTFILE.nwchem 2>&1`;
  ok($output =~ /Vector\s+14\s+Occ=2\..*E=-4\..*Symmetry=eu/, 'nwchem runs');

  skip 'modules not installed', 3 if ! -f '/etc/profile.d/modules.sh';
  `/bin/ls /opt/modulefiles/applications/nwchem/[0-9]* 2>&1`;
  ok($? == 0, 'nwchem module installed');
  `/bin/ls /opt/modulefiles/applications/nwchem/.version.[0-9]* 2>&1`;
  ok($? == 0, 'nwchem version module installed');
  ok(-l '/opt/modulefiles/applications/nwchem/.version',
     'nwchem version module link created');

}

`rm -f $TESTFILE* s2*`;
