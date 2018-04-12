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

if ($ENV{"USER"} eq "root") {
  print STDERR "Aborting\n";
  print STDERR "Due to openmpi restictions, this test reports spurious errors when run by root\n";
  print STDERR "Rerun as a non-root user\n";
  exit(1);
}

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

open(OUT, ">${TESTFILE}cuda.nwchem");
print OUT <<END;
#
# Test for CCSD[T] & CCDS(T) codes in the TCE module
# Reference data obtained by an independent code are
#
# CCSD(T) -0.21632467284
# CCSD[T] -0.21640986353
#
# in units of hartree.
#
# The (T) & [T] codes and the reference data have been
# provided by Alex A. Auer (University of Waterloo)
#
start tce_ccsd_t_h2o

echo

geometry units bohr
O     0.00000000     0.00000000     0.22138519
H     0.00000000    -1.43013023    -0.88554075
H     0.00000000     1.43013023    -0.88554075
end

basis spherical
H library cc-pVDZ
O library cc-pVDZ
end

scf
thresh 1.0e-10
tol2e 1.0e-10
singlet
rhf
end

tce
ccsd(t)
io ga
cuda 1
end

task tce energy
END
close(OUT);

open(OUT, ">$TESTFILE.sh");
print OUT <<END;
module load nwchem \$1
if test ! -e \$HOME/.nwchemrc; then
  ln -s /opt/nwchem/.nwchemrc \$HOME/
fi
mpirun -np 4 /opt/nwchem/bin/nwchem $TESTFILE\$2.nwchem
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
  $output = `bash $TESTFILE.sh CUDAVER 2>&1`;
  ok($output =~ /Total SCF energy =   -794.820927/, 'nwchem runs');
  SKIP: {
      skip 'CUDA_VISIBLE_DEVICES undef', 1
      if ! defined($ENV{'CUDA_VISIBLE_DEVICES'});
      $output = `module load nwchem CUDAVER;bash $TESTFILE.sh CUDAVER cuda 2>&1`;
      ok($output =~ /CCSD\(T\) total energy \/ hartree       =       -76.243132/, 'nwchem cuda runs');
    }

  `/bin/ls /opt/modulefiles/applications/nwchem/[0-9]* 2>&1`;
  ok($? == 0, 'nwchem module installed');
  `/bin/ls /opt/modulefiles/applications/nwchem/.version.[0-9]* 2>&1`;
  ok($? == 0, 'nwchem version module installed');
  ok(-l '/opt/modulefiles/applications/nwchem/.version',
     'nwchem version module link created');

}

`rm -f $TESTFILE* s2* tce*`;
