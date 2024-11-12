#
# **************************************************************
# *                                                            *
# * Author: sunbin (2024)                                      *
# * URL: https://ftp.gnu.org/pub/gnu/global/				   *
# *                                                            *
# * Copyright notice:                                          *
# * Free use of this C++ Makefile template is permitted under  *
# * the guidelines and in accordance with the the MIT License  *
# * http://www.opensource.org/licenses/MIT                     *
# *                                                            *
# **************************************************************
#

TOPDIR := $(shell /bin/pwd)
core_src_dir = $(TOPDIR)

build_dir = $(TOPDIR)/build

talloc_src_dir = $(core_src_dir)/talloc-2.2.0
talloc_build_dir = $(build_dir)/talloc-2.2.0
talloc_dir_name = talloc-2.2.0

tdb_src_dir = $(core_src_dir)/tdb-1.4.10
tdb_build_dir = $(build_dir)/tdb-1.4.10
tdb_dir_name = tdb-1.4.10

tevent_src_dir = $(core_src_dir)/tevent-0.16.1
tevent_build_dir = $(build_dir)/tevent-0.16.1
tevent_dir_name = tevent-0.16.1

lmdb_src_dir = $(core_src_dir)/lmdb-LMDB_0.9.31
lmdb_build_dir = $(build_dir)/lmdb-LMDB_0.9.31
lmdb_dir_name = lmdb-LMDB_0.9.31

ldb_src_dir = $(core_src_dir)/ldb-2.9.1
ldb_build_dir = $(build_dir)/ldb-2.9.1
ldb_dir_name = ldb-2.9.1


all: build_talloc build_tdb build_tevent build_lmdb build_ldb 

build_global:
	@echo "---------- copy global files ----------"
	@if [ -d $(build_dir) ]; then rm -rf $(global_build_dir); fi
	@mkdir -p $(global_build_dir)
	@(mkdir -p $(global_build_dir)/{BUILD,BUILDROOT,RPMS,SOURCES,SPECS,SRPMS})
	@(cd $(global_build_dir)/SOURCES; \
			cp -a $(global_src_dir)/config/* $(global_build_dir)/SOURCES; \
			cp -a $(global_src_dir) $(global_dir_name); \
			tar -zcvf $(global_dir_name).tar.gz $(global_dir_name); rm -rf $(global_dir_name); )

	@echo "---------- copy spec ----------"
	@(cp -af $(global_src_dir)/global.spec $(global_build_dir)/SPECS)
	@echo "---------- build global ----------"
	@(rpmbuild -ba --define="_topdir $(global_build_dir)" $(global_build_dir)/SPECS/global.spec)


build_talloc:
	@echo "---------- copy talloc files ----------"
	@if [ -d $(build_dir) ]; then rm -rf $(talloc_build_dir); fi
	@mkdir -p $(talloc_build_dir)
	@(mkdir -p $(talloc_build_dir)/{BUILD,BUILDROOT,RPMS,SOURCES,SPECS,SRPMS})
	@(cd $(talloc_build_dir)/SOURCES; \
			cp -a $(talloc_src_dir)/config/* $(talloc_build_dir)/SOURCES; \
			cp -a $(talloc_src_dir) $(talloc_dir_name); \
			tar -zcvf $(talloc_dir_name).tar.gz $(talloc_dir_name); rm -rf $(talloc_dir_name); )

	@echo "---------- copy spec ----------"
	@(cp -af $(talloc_src_dir)/talloc.spec $(talloc_build_dir)/SPECS)
	@echo "---------- build global ----------"
	@(rpmbuild -ba --define="_topdir $(talloc_build_dir)" $(talloc_build_dir)/SPECS/talloc.spec)

install_talloc:
	@(rpm -ivh $(talloc_build_dir)/RPMS/x86_64/* --force)

build_tdb:
	@echo "---------- copy tdb files ----------"
	@if [ -d $(build_dir) ]; then rm -rf $(tdb_build_dir); fi
	@mkdir -p $(tdb_build_dir)
	@(mkdir -p $(tdb_build_dir)/{BUILD,BUILDROOT,RPMS,SOURCES,SPECS,SRPMS})
	@(cd $(tdb_build_dir)/SOURCES; \
			cp -a $(tdb_src_dir)/config/* $(tdb_build_dir)/SOURCES; \
			cp -a $(tdb_src_dir) $(tdb_dir_name); \
			tar -zcvf $(tdb_dir_name).tar.gz $(tdb_dir_name); rm -rf $(tdb_dir_name); )

	@echo "---------- copy spec ----------"
	@(cp -af $(tdb_src_dir)/tdb.spec $(tdb_build_dir)/SPECS)
	@echo "---------- build tdb ----------"
	@(rpmbuild -ba --define="_topdir $(tdb_build_dir)" $(tdb_build_dir)/SPECS/tdb.spec)


build_tevent:
	@echo "---------- copy tevent files ----------"
	@if [ -d $(build_dir) ]; then rm -rf $(tevent_build_dir); fi
	@mkdir -p $(tevent_build_dir)
	@(mkdir -p $(tevent_build_dir)/{BUILD,BUILDROOT,RPMS,SOURCES,SPECS,SRPMS})
	@(cd $(tevent_build_dir)/SOURCES; \
			cp -a $(tevent_src_dir)/config/* $(tevent_build_dir)/SOURCES; \
			cp -a $(tevent_src_dir) $(tevent_dir_name); \
			tar -zcvf $(tevent_dir_name).tar.gz $(tevent_dir_name); rm -rf $(tevent_dir_name); )

	@echo "---------- copy spec ----------"
	@(cp -af $(tevent_src_dir)/tevent.spec $(tevent_build_dir)/SPECS)
	@echo "---------- build tevent ----------"
	@(rpmbuild -ba --define="_topdir $(tevent_build_dir)" $(tevent_build_dir)/SPECS/tevent.spec)


build_lmdb:
	@echo "---------- copy lmdb files ----------"
	@if [ -d $(build_dir) ]; then rm -rf $(lmdb_build_dir); fi
	@mkdir -p $(lmdb_build_dir)
	@(mkdir -p $(lmdb_build_dir)/{BUILD,BUILDROOT,RPMS,SOURCES,SPECS,SRPMS})
	@(cd $(lmdb_build_dir)/SOURCES; \
			cp -a $(lmdb_src_dir)/config/* $(lmdb_build_dir)/SOURCES; \
			cp -a $(lmdb_src_dir) $(lmdb_dir_name); \
			tar -zcvf $(lmdb_dir_name).tar.gz $(lmdb_dir_name); rm -rf $(lmdb_dir_name); )

	@echo "---------- copy spec ----------"
	@(cp -af $(lmdb_src_dir)/lmdb.spec $(lmdb_build_dir)/SPECS)
	@echo "---------- build lmdb ----------"
	@(rpmbuild -ba --define="_topdir $(lmdb_build_dir)" $(lmdb_build_dir)/SPECS/lmdb.spec)


build_ldb:
	@echo "---------- copy ldb files ----------"
	@if [ -d $(build_dir) ]; then rm -rf $(ldb_build_dir); fi
	@mkdir -p $(ldb_build_dir)
	@(mkdir -p $(ldb_build_dir)/{BUILD,BUILDROOT,RPMS,SOURCES,SPECS,SRPMS})
	@(cd $(ldb_build_dir)/SOURCES; \
			cp -a $(ldb_src_dir)/config/* $(ldb_build_dir)/SOURCES; \
			cp -a $(ldb_src_dir) $(ldb_dir_name); \
			tar -zcvf $(ldb_dir_name).tar.gz $(ldb_dir_name); rm -rf $(ldb_dir_name); )

	@echo "---------- copy spec ----------"
	@(cp -af $(ldb_src_dir)/ldb.spec $(ldb_build_dir)/SPECS)
	@echo "---------- build ldb ----------"
	@(rpmbuild -ba --define="_topdir $(ldb_build_dir)" $(ldb_build_dir)/SPECS/ldb.spec)


clean:
	-rm -rf $(build_dir)
