# $Id$
#
# @Copyright@
# 
# 				Rocks(r)
# 		         www.rocksclusters.org
# 		         version 5.6 (Emerald Boa)
# 		         version 6.1 (Emerald Boa)
# 
# Copyright (c) 2000 - 2013 The Regents of the University of California.
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
PKGROOT = /opt/nwchem

-include $(ROCKSROOT)/etc/Rules.mk
include Rules.mk
include pull.mk

CC = gcc
FC = gfortran
ifeq ("$(ROLLCOMPILER)", "intel")
  CC = icc
  FC = ifort
else ifeq ("$(ROLLCOMPILER)", "pgi")
  CC = pgcc
  FC = pgf90
endif

COMPILERSETUP =  \
  if test -e /etc/profile.d/modules.sh; then \
    . /etc/profile.d/modules.sh; \
    module load $(ROLLCOMPILER) || true; \
    module load mkl || true; \
  fi; \
  echo === Compiler and version ===; \
  $(CC) --version; \
  echo === MKL_ROOT ===; \
  echo $${MKL_ROOT}; \
  export MKLLIB=`find $${MKL_ROOT}/lib/* -maxdepth 0 | head -1`; \
  export BLASOPT="-L$${MKLLIB} -Wl,--start-group -lmkl_intel_ilp64 \
                  -lmkl_sequential -lmkl_core -Wl,--end-group -lpthread"

ifeq ("$(ROLLNETWORK)", "eth")
  MPIMODULE = $(ROLLMPI)
else
  MPIMODULE = $(ROLLMPI)_$(ROLLNETWORK)
endif

MPISETUP = \
  if test -e /etc/profile.d/modules.sh; then \
    . /etc/profile.d/modules.sh; \
    module load $(MPIMODULE) || true; \
  fi; \
  if test -z "$${MPIHOME}"; then \
    export MPIHOME=/opt/$(ROLLMPI); \
  fi; \
  echo === MPIHOME ===; \
  echo $${MPIHOME}

ifeq ("$(ROLLNETWORK)", "mx")
  ARMCI_NETWORK = GM
else ifeq ("$(ROLLNETWORK)", "ib")
  ARMCI_NETWORK = OPENIB
endif

ifeq ("$(MPIMODULE)", "openmpi_mx")
  MPI_LINK = -lmpi_f77 -lmpi -L/opt/mx/lib -lmyriexpress -lrt -lnsl -lutil -ldl -lm -lrt -lnsl -lutil
else ifeq ("$(MPIMODULE)", "openmpi_ib")
  MPI_LINK = -lmpi_f77 -lmpi -lrdmacm -libverbs -lnsl -lutil -ldl -lnsl -lutil
else ifeq ("$(MPIMODULE)", "mvapich2_ib")
  MPI_LINK = -L/usr/lib64 -Wl,-rpath,${MPI_LIB} -lmpich -lopa -lmpl -lpthread -llimic2 -lrdmacm -libverbs -libumad -ldl -lrt
else ifeq ("$(MPIMODULE)", "vsmp_ib")
  MPI_LINK = -Wl,-rpath -Wl,${MPI_LIB} -lmpich -lopa -lmpl -lrt -lpthread
endif

build: $(SRC_DIRS)
	perl -pi -e 's/-m(arch|tune)=native//g' $(SOURCE_DIR)/src/config/makefile.h
	( \
	  $(COMPILERSETUP); \
	  $(MPISETUP); \
	  cd $(SOURCE_DIR); \
	  export LARGE_FILES=TRUE; \
	  export NWCHEM_TARGET=LINUX64; \
	  export ARMCI_NETWORK=$(ARMCI_NETWORK); \
	  export USE_MPI=y; \
	  export USE_MPIF=y; \
	  export USE_MPIF4=y; \
	  export LIBMPI="$(MPI_LINK)"; \
	  export MPI_LIB=$${MPIHOME}/lib; \
	  export MPI_INCLUDE=$${MPIHOME}/include; \
	  export NWCHEM_TOP=/tmp/$(SOURCE_DIR); \
	  rm -f /tmp/$(SOURCE_DIR); \
	  ln -s `pwd` /tmp/$(SOURCE_DIR); \
	  cd src; \
	  touch config/nwchem_config.h; \
	  make nwchem_config NWCHEM_MODULES=all; \
	  make -j 16 FC=$(FC) CC=$(CC) \
	)
	@echo "::: Package $(NAME) build complete :::"

install::
	mkdir -p -m 755 $(ROOT)/$(PKGROOT)
	mkdir -p -m 755 $(ROOT)/$(PKGROOT)/bin
	mkdir -p -m 755 $(ROOT)/$(PKGROOT)/data
	cp patch-files/dotnwchemrc $(ROOT)/$(PKGROOT)/.nwchemrc
	perl -pi -e "s!NWCHEM_LIB!$(PKGROOT)/data!" $(ROOT)/$(PKGROOT)/.nwchemrc; \
	( \
	  cd $(SOURCE_DIR); \
	  cp bin/LINUX64/nwchem $(ROOT)/$(PKGROOT)/bin; \
	  cp -r src/basis/libraries $(ROOT)/$(PKGROOT)/data; \
	  cp -r src/data $(ROOT)/$(PKGROOT); \
	  cp -r src/nwpw/libraryps $(ROOT)/$(PKGROOT)/data; \
	  cp -r src/tools/global/testing/ipcreset $(ROOT)/$(PKGROOT)/bin; \
	  find $(ROOT)/$(PKGROOT)/data -perm 0750 -exec chmod 0755 {} \; ; \
	  find $(ROOT)/$(PKGROOT)/data -perm 0640 -exec chmod 0644 {} \; \
	)
	@echo "::: Package $(NAME) build complete :::"

clean::
	rm -rf $(SOURCE_DIR)
