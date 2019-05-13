ifndef ROLLCOMPILER
  ROLLCOMPILER = gnu
endif
COMPILERNAME := $(firstword $(subst /, ,$(ROLLCOMPILER)))

ifndef ROLLMPI
  ROLLMPI = rocks-openmpi
endif
MPINAME := $(firstword $(subst /, ,$(ROLLMPI)))

CUDAVERSION = cuda
CUDABUILD = no
ifneq ("$(ROLLOPTS)", "$(subst cuda=,,$(ROLLOPTS))")
  CUDAVERSION = $(subst cuda=,,$(filter cuda=%,$(ROLLOPTS)))
  CUDABUILD = yes
endif

NAME           = sdsc-nwchem
VERSION        = 6.8
RELEASE        = 1
PKGROOT        = /opt/nwchem

SRC_SUBDIR     = nwchem

SOURCE_NAME    = nwchem
SOURCE_SUFFIX  = tar.bz2
SOURCE_VERSION = $(VERSION)
SOURCE_PKG     = $(SOURCE_NAME)-$(SOURCE_VERSION).$(SOURCE_SUFFIX)
SOURCE_DIR     = nwchem-$(VERSION)

GA_RELEASE_NO=5.6.3

TAR_BZ2_PKGS    = $(SOURCE_PKG)

RPM.EXTRAS     = AutoReq:No\nAutoProv:No
RPM.PREFIX     = $(PKGROOT)
