ifndef ROLLCOMPILER
  ROLLCOMPILER = gnu
endif
COMPILERNAME := $(firstword $(subst /, ,$(ROLLCOMPILER)))

ifndef ROLLMPI
  ROLLMPI = openmpi
endif
MPINAME := $(firstword $(subst /, ,$(ROLLMPI)))

NAME           = nwchem_$(COMPILERNAME)_$(MPINAME)
VERSION        = 6.5
RELEASE        = 1
PKGROOT        = /opt/nwchem

SRC_SUBDIR     = nwchem

SOURCE_NAME    = Nwchem
SOURCE_SUFFIX  = tar.gz
SOURCE_VERSION = 6.5.revision26243-src.2014-09-10
SOURCE_PKG     = $(SOURCE_NAME)-$(SOURCE_VERSION).$(SOURCE_SUFFIX)
SOURCE_DIR     = $(SOURCE_PKG:%.$(SOURCE_SUFFIX)=%)

TAR_GZ_PKGS    = $(SOURCE_PKG)

RPM.EXTRAS     = AutoReq:No
