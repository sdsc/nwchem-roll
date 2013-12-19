# SDSC "nwchem" roll

## Overview

This roll bundles the NWCHEM computational chemistry package.

For more information about NWCHEM please visit the official web page:

- <a href="http://www.nwchem-sw.org/index.php" target="_blank">NWCHEM</a> is a
set of computational chemistry tools that are scalable both in their ability to
treat large scientific computational chemistry problems efficiently, and in
their use of available parallel computing resources from high-performance
parallel supercomputers to conventional workstation clusters.


## Requirements

To build/install this roll you must have root access to a Rocks development
machine (e.g., a frontend or development appliance).

If your Rocks development machine does *not* have Internet access you must
download the appropriate nwchem source file(s) using a machine that does
have Internet access and copy them into the `src/<package>` directories on your
Rocks development machine.


## Dependencies

Unknown at this time.


## Building

To build the nwchem-roll, execute these instructions on a Rocks development
machine (e.g., a frontend or development appliance):

```shell
% make default 2>&1 | tee build.log
% grep "RPM build error" build.log
```

If nothing is returned from the grep command then the roll should have been
created as... `nwchem-*.iso`. If you built the roll on a Rocks frontend then
proceed to the installation step. If you built the roll on a Rocks development
appliance you need to copy the roll to your Rocks frontend before continuing
with installation.

This roll source supports building with different compilers and for different
network fabrics and mpi flavors.  By default, it builds using the gnu compilers
for openmpi ethernet.  To build for a different configuration, use the
`ROLLCOMPILER`, `ROLLMPI` and `ROLLNETWORK` make variables, e.g.,

```shell
make ROLLCOMPILER=intel ROLLMPI=mpich2 ROLLNETWORK=mx 
```

The build process currently supports one or more of the values "intel", "pgi",
and "gnu" for the `ROLLCOMPILER` variable, defaulting to "gnu".  It supports
`ROLLMPI` values "openmpi", "mpich2", and "mvapich2", defaulting to "openmpi".
It uses any `ROLLNETWORK` variable value(s) to load appropriate mpi modules,
assuming that there are modules named `$(ROLLMPI)_$(ROLLNETWORK)` available
(e.g., `openmpi_ib`, `mpich2_mx`, etc.).

If the `ROLLCOMPILER`, `ROLLNETWORK` and/or `ROLLMPI` variables are specified,
their values are incorporated into the names of the produced roll and rpms, e.g.,

```shell
make ROLLCOMPILER=intel ROLLMPI=mvapich2 ROLLNETWORK=ib
```
produces a roll with a name that begins "`nwchem_intel_mvapich2_ib`"; it
contains and installs similarly-named rpms.


## Installation

To install, execute these instructions on a Rocks frontend:

```shell
% rocks add roll *.iso
% rocks enable roll nwchem
% cd /export/rocks/install
% rocks create distro
% rocks run roll nwchem | bash
```

In addition to the software itself, the roll installs nwchem environment
module files in:

```shell
/opt/modulefiles/applications/.(compiler)/nwchem
```


## Testing

The nwchem-roll includes a test script which can be run to verify proper
installation of the nwchem-roll documentation, binaries and module files. To
run the test scripts execute the following command(s):

```shell
% /root/rolltests/nwchem.t 
ok 1 - nwchem is installed
ok 2 - nwchem test run
ok 3 - nwchem module installed
ok 4 - nwchem version module installed
ok 5 - nwchem version module link created
1..5
```

