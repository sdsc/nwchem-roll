NAME               = nwchem_$(ROLLCOMPILER)_$(ROLLMPI)_$(ROLLNETWORK)
VERSION            = 6.3
RELEASE            = 1
PKGROOT            = /opt/nwchem

SRC_SUBDIR         = nwchem

SOURCE_NAME        = nwchem
SOURCE_VERSION     = $(VERSION)
SOURCE_SUFFIX      = tar.gz
SOURCE_PKG         = $(SOURCE_NAME)-$(SOURCE_VERSION).$(SOURCE_SUFFIX)
SOURCE_DIR         = $(SOURCE_PKG:%.$(SOURCE_SUFFIX)=%)

TAR_GZ_PKGS        = $(SOURCE_PKG)
