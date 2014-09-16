ifndef ROLLCOMPILER
  ROLLCOMPILER = gnu
endif
COMPILERNAME := $(firstword $(subst /, ,$(ROLLCOMPILER)))

ifndef ROLLMPI
  ROLLMPI = openmpi
endif

ifndef ROLLNETWORK
  ROLLNETWORK = eth
endif

NAME           = nwchem_$(COMPILERNAME)_$(ROLLMPI)_$(ROLLNETWORK)
VERSION        = 6.3
RELEASE        = 3
PKGROOT        = /opt/nwchem

SRC_SUBDIR     = nwchem

SOURCE_NAME    = nwchem
SOURCE_SUFFIX  = tar.gz
SOURCE_VERSION = $(VERSION)
SOURCE_PKG     = $(SOURCE_NAME)-$(SOURCE_VERSION).$(SOURCE_SUFFIX)
SOURCE_DIR     = $(SOURCE_PKG:%.$(SOURCE_SUFFIX)=%)

TAR_GZ_PKGS    = $(SOURCE_PKG)

RPM.EXTRAS     = AutoReq:No
