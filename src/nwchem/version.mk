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

NWCHEM_PATCHES = Tddft_mxvec20 Tools_lib64 Config_libs66 Cosmo_meminit Sym_abelian Xccvs98 Dplot_tolrho Driver_smalleig Ga_argv Raman_displ Ga_defs Zgesvd Cosmo_dftprint Txs_gcc6 Gcc6_optfix Util_gnumakefile Util_getppn Gcc6_macs_optfix Notdir_fc Xatom_vdw Hfmke Cdfti2nw66

$(NWCHEM_PATCHES):
	$(eval PATCH_NAME  = $@)
	echo "PATCH NAME $(PATCH_NAME)"
	$(eval $(PATCH_NAME)_SUFFIX = patch.gz)
	$(eval $(PATCH_NAME)_PKG = $(PATCH_NAME).$($(PATCH_NAME)_SUFFIX))
	echo "PACKAGE $($(PATCH_NAME)_PKG)"
	$(eval PATCH_PKGS  += $($(PATCH_NAME)_PKG))
	$(eval PATCHES  += $(PATCH_NAME).patch

GA_RELEASE_NO=5.6.3

TAR_BZ2_PKGS    = $(SOURCE_PKG)

RPM.EXTRAS     = AutoReq:No\nAutoProv:No
RPM.PREFIX     = $(PKGROOT)
