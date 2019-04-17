# Id$
#
# @Copyright@
#
# 				Rocks(r)
# 		         www.rocksclusters.org
# 		         version 7.0 (Manzanita)
#
# Copyright (c) 2000 - 2017 The Regents of the University of California.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
# 1. Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright
# notice unmodified and in its entirety, this list of conditions and the
# following disclaimer in the documentation and/or other materials provided
# with the distribution.
#
# 3. All advertising and press materials, printed or electronic, mentioning
# features or use of this software must display the following acknowledgement:
#
# 	"This product includes software developed by the Rocks(r)
# 	Cluster Group at the San Diego Supercomputer Center at the
# 	University of California, San Diego and its contributors."
#
# 4. Except as permitted for the purposes of acknowledgment in paragraph 3,
# neither the name or logo of this software nor the names of its
# authors may be used to endorse or promote products derived from this
# software without specific prior written permission.  The name of the
# software includes the following terms, and any derivatives thereof:
# "Rocks", "Rocks Clusters", and "Avalanche Installer".  For licensing of
# the associated name, interested parties should contact Technology
# Transfer & Intellectual Property Services, University of California,
# San Diego, 9500 Gilman Drive, Mail Code 0910, La Jolla, CA 92093-0910,
# Ph: (858) 534-5815, FAX: (858) 534-7345, E-MAIL:invent@ucsd.edu
#
# THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS''
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
# THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS
# BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
# IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# @Copyright@
#
# $Log$

REDHAT.ROOT = $(CURDIR)/../../

-include $(ROCKSROOT)/etc/Rules.mk
include Rules.mk
include $(SDSCDEVEL)/Pull.mk
include $(SDSCDEVEL)/Rules.mk

.PHONY: $(NWCHEM_PATCHES)

CACHE_DIR=$(REDHAT.ROOT)/cache/bin

$(NAME).spec: DESCRIPTION LICENSE

MODULE_LOAD_NWCHEM_CUDA = $(call MODULE_LOAD_PACKAGE, $(CUDAVERSION), CUDAHOME)
DESCRIBE_NWCHEM_CUDA = echo built with cuda $(call GET_MODULE_VERSION, $(CUDAVERSION))

DESCRIPTION:
	echo "CUDAVERSION $(CUDAVERSION)"
	$(MODULE_LOAD_CC); \
	( \
	  $(DESCRIBE_PKG); \
	  $(DESCRIBE_CC); \
	  $(DESCRIBE_MKL); \
	  $(DESCRIBE_MPI); \
          if test "$(CUDABUILD)" = "yes"; then \
             $(DESCRIBE_NWCHEM_CUDA); \
          fi \
	) > $@

LICENSE: $(SRC_DIRS)
	$(CHECK_LICENSE_FILES)
	echo ECL > $@

nwchempatchdownload : $(NWCHEM_PATCHES)
	for NWCHEM_PATCH in $(PATCH_PKGS); do \
           echo "::: Downloading $(DL.SERVER)/$(DL.PATH)/$${NWCHEM_PATCH} :::"; \
           if [ -f $${NWCHEM_PATCH} ]; then \
                echo "::: $${NWCHEM_PATCH} exists. Skipping... :::" ; \
           else \
                $(DL.CMD) $(DL.OPTS) $(DL.SERVER)/$(DL.PATH)/$${NWCHEM_PATCH} ; \
                echo "::: Verifying size of $${NWCHEM_PATCH} :::" ; \
                $(GREP.CMD) `$(STAT.CMD) --printf="%s" $${NWCHEM_PATCH}` $(VERIFY.HASHES) ; \
                echo "::: Verifying hash of $${NWCHEM_PATCH} :::" ; \
                $(GREP.CMD) `$(VERIFY.CMD) $(VERIFY.OPTS) $${NWCHEM_PATCH} ` $(VERIFY.HASHES) ; \
                echo "" ; \
           fi; \
           echo "::: Unbundling $${NWCHEM_PATCH} :::"; \
           gunzip $${NWCHEM_PATCH}; \
           echo ""; \
        done


build: $(SRC_DIRS) nwchempatchdownload
	perl -pi -e 's/-m(arch|tune)=native//g' $(SOURCE_DIR)/src/config/makefile.h
	patch $(SOURCE_DIR)/src/atomscf/cguess.fh patch-files/cguess.fh.patch
	mkdir -p $(CACHE_DIR)
	( \
	  $(MODULE_LOAD_CC); \
	  $(MODULE_LOAD_MKL); \
	  export MKLLIB=$${MKLHOME}/lib/intel64; \
	  $(MODULE_LOAD_MPI); \
          MPI_LINK=`mpif90 -show|sed 's/.*-L/-L/'`; \
	  cd $(SOURCE_DIR); \
          for NWCHEM_PATCH in $(NWCHEM_PATCHES); do \
                patch -p0 < $${NWCHEM_PATCH}.patch; \
          done; \
	  export LARGE_FILES=TRUE; \
	  export NWCHEM_TARGET=LINUX64; \
	  export ARMCI_NETWORK=OPENIB; \
          export USE_NOFSCHECK=TRUE; \
          export USE_NOIO=TRUE; \
          export USE_OPENMP=TRUE; \
	  export USE_MPI=y; \
	  export SE_MPIF=y; \
	  export SE_MPIF4=y; \
	  export MPI_LIB=$${MPIHOME}/lib; \
	  export MPI_INCLUDE=$${MPIHOME}/include; \
          export LIBMPI="$${MPI_LINK} -libverbs   -lrt  -lpthread"; \
	  export NWCHEM_TOP=/tmp/$(SOURCE_DIR); \
          export MA_USE_ARMCI_NEW=Y; \
          export LIB_DEFINES=-DDFLT_TOT_MEM=98304000; \
          export MSG_COMMS=MPI; \
          export IB_INCLUDE=/usr/include/inifiniband; \
          export IB_LIB_NAME=-libumad -libverbs; \
	  export BLASOPT="-L$${MKLLIB} -Wl,--start-group -lmkl_intel_ilp64 \
	                  -lmkl_sequential -lmkl_core -Wl,--end-group -lpthread"; \
          export HAS_BLAS=yes; \
	  rm -f /tmp/$(SOURCE_DIR); \
	  ln -s `pwd` /tmp/$(SOURCE_DIR); \
	  cd src; \
	  touch config/nwchem_config.h; \
	  make nwchem_config NWCHEM_MODULES=all; \
          make -j 16 FC=$(FC) CC=$(CC); \
	  cp ../bin/LINUX64/nwchem $(CACHE_DIR); \
          if test "$(CUDABUILD)" = "yes"; then \
              make realclean; \
              $(MODULE_LOAD_NWCHEM_CUDA); \
              export TCE_CUDA=Y; \
              export CUDA_LIBS="-L$${CUDAHOME}/lib64 -lcudart"; \
              export CUDA_INCLUDE="-I $${CUDAHOME}/include"; \
              export CUDA_FLAGS="-gencode arch=compute_30,code=sm_30 -gencode arch=compute_37,code=sm_37 -gencode arch=compute_52,code=sm_52 -gencode arch=compute_60,code=sm_60"; \
              cd ..; \
	      rm -f /tmp/$(SOURCE_DIR); \
              ln -s `pwd` /tmp/$(SOURCE_DIR); \
              cd src; \
              touch config/nwchem_config.h; \
	      make nwchem_config NWCHEM_MODULES=all; \
              make -j 16 FC=$(FC) CC=$(CC) CUDA=nvcc; \
	      cp ../bin/LINUX64/nwchem $(CACHE_DIR)/nwchem.cuda; \
          fi; \
	)
	@echo "::: Package $(NAME) build complete :::"

install::
	mkdir -p -m 755 $(ROOT)/$(PKGROOT) $(ROOT)/$(PKGROOT)/{bin,data}
	cp dotnwchemrc $(ROOT)/$(PKGROOT)/.nwchemrc
	perl -pi -e "s!NWCHEM_LIB!$(PKGROOT)/data!" $(ROOT)/$(PKGROOT)/.nwchemrc; \
	( \
	  cd $(SOURCE_DIR); \
	  cp $(CACHE_DIR)/* $(ROOT)/$(PKGROOT)/bin; \
	  cp -r src/basis/libraries $(ROOT)/$(PKGROOT)/data; \
	  cp -r src/data $(ROOT)/$(PKGROOT); \
	  cp -r src/nwpw/libraryps $(ROOT)/$(PKGROOT)/data; \
	  cp -r src/tools/ga-$(GA_RELEASE_NO)/global/testing/ipcreset $(ROOT)/$(PKGROOT)/bin; \
          chmod 0755 $(ROOT)/$(PKGROOT)/bin/ipcreset; \
	  find $(ROOT)/$(PKGROOT)/data -perm 0750 -exec chmod 0755 {} \; ; \
	  find $(ROOT)/$(PKGROOT)/data -perm 0640 -exec chmod 0644 {} \; \
	)
	$(INSTALL_LICENSE_FILES)
	@echo "::: Package $(NAME) build complete :::"

clean::
	rm -rf $(SOURCE_DIR) DESCRIPTION LICENSE $(CACHE_DIR) $(PATCHES)
