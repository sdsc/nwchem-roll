NAME       = sdsc-nwchem-roll-test
VERSION    = 2
RELEASE    = 0
PKGROOT    = /root/rolltests

ifneq ("$(ROLLOPTS)", "$(subst cuda=,,$(ROLLOPTS))")
  CUDAVER = $(subst cuda=,,$(filter cuda=%,$(ROLLOPTS)))
endif


RPM.EXTRAS = AutoReq:No\nAutoProv:No
RPM.FILES  = $(PKGROOT)/nwchem.t
