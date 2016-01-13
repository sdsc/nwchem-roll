ifndef ROLLCOMPILER
  ROLLCOMPILER = gnu
endif
COMPILERNAME := $(firstword $(subst /, ,$(ROLLCOMPILER)))

ifndef ROLLMPI
  ROLLMPI = rocks-openmpi
endif
MPINAME := $(firstword $(subst /, ,$(ROLLMPI)))

NAME           = sdsc-nwchem
VERSION        = 6.6
RELEASE        = 0
PKGROOT        = /opt/nwchem

SRC_SUBDIR     = nwchem

SOURCE_NAME    = Nwchem
SOURCE_SUFFIX  = tar.gz
SOURCE_VERSION = 6.6.revision27746-src.2015-10-20
SOURCE_PKG     = $(SOURCE_NAME)-$(SOURCE_VERSION).$(SOURCE_SUFFIX)
SOURCE_DIR     = nwchem-$(VERSION)

TAR_GZ_PKGS    = $(SOURCE_PKG)

RPM.EXTRAS     = AutoReq:No
