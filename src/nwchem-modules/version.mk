NAME        = nwchem-modules
RELEASE     = 2
PKGROOT     = /opt/modulefiles/applications/nwchem

VERSION_SRC = $(REDHAT.ROOT)/src/nwchem/version.mk
VERSION_INC = version.inc
include $(VERSION_INC)

RPM.EXTRAS  = AutoReq:No
