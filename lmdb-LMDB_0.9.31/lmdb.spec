# The files themselves are in several subdirectories and need to be prefixed wit this.
%global archive_path libraries/lib%{name}

Name:           lmdb
Version:        0.9.31
Release:        99%{?dist}
Summary:        Memory-mapped key-value database

License:        OpenLDAP
URL:            http://symas.com/mdb/
Source0:        https://github.com/LMDB/lmdb/archive/LMDB_%{version}.tar.gz#/%{name}-LMDB_%{version}.tar.gz
Source1:        lmdb.pc.in

BuildRequires: make
BuildRequires: gcc
BuildRequires: doxygen

Requires:       %{name}-libs%{?_isa} = %{version}-%{release}

# Patch description in the corresponding file
Patch0: lmdb-make.patch
Patch1: lmdb-s390-check.patch
Patch2: lmdb-covscan.patch
Patch3: tis-increase-mdb-idl-logn.patch

%description
LMDB is an ultra-fast, ultra-compact key-value embedded data
store developed by Symas for the OpenLDAP Project. By using memory-mapped files,
it provides the read performance of a pure in-memory database while still
offering the persistence of standard disk-based databases, and is only limited
to the size of the virtual address space.

%package        libs
Summary:        Shared libraries for %{name}

%description    libs
The %{name}-libs package contains shared libraries necessary for running
applications that use %{name}.

%package        devel
Summary:        Development files for %{name}
Requires:       %{name}-libs%{?_isa} = %{version}-%{release}

%description    devel
The %{name}-devel package contains libraries and header files for
developing applications that use %{name}.

%package        doc
Summary:        Documentation files for %{name}
BuildArch:      noarch

%description    doc
The %{name}-doc package contains automatically generated documentation for %{name}.


%prep
%setup -q -n %{name}-LMDB_%{version}
%patch0 -p1 -b .make
%patch1 -p1 -b .s390-check
%patch2 -p1 -b .covscan
%patch3 -p1 

%build
pushd %{archive_path}
make LDFLAGS="%{build_ldflags}" XCFLAGS="%{optflags}" %{?_smp_mflags}
# Build doxygen documentation
doxygen
# remove unpackaged files
rm -f Doxyfile
rm -rf man # Doxygen generated manpages
popd

%install
pushd %{archive_path}
# make install expects existing directory tree
mkdir -m 0755 -p %{buildroot}{%{_bindir},%{_includedir}}
mkdir -m 0755 -p %{buildroot}{%{_libdir}/pkgconfig,%{_mandir}/man1}
make DESTDIR=%{buildroot} prefix=%{_prefix} libdir=%{_libdir} mandir=%{_mandir} install
popd

# Install pkgconfig file
sed -e 's:@PREFIX@:%{_prefix}:g' \
    -e 's:@EXEC_PREFIX@:%{_exec_prefix}:g' \
    -e 's:@LIBDIR@:%{_libdir}:g' \
    -e 's:@INCLUDEDIR@:%{_includedir}:g' \
    -e 's:@PACKAGE_VERSION@:%{version}:g' \
    %{SOURCE1} >lmdb.pc
install -Dpm 0644 -t %{buildroot}%{_libdir}/pkgconfig lmdb.pc

%check
%if 0%{?rhel} == 6 && "%{_arch}" == "ppc64"
  # rhel6 ppc64: skip unit tests
  exit 0
%endif

pushd %{archive_path}
rm -rf testdb
LD_LIBRARY_PATH=$PWD make test
popd

%ldconfig_scriptlets libs


%files
%{_bindir}/*
%{_mandir}/man1/*

%files libs
%doc %{archive_path}/COPYRIGHT
%doc %{archive_path}/CHANGES
%license %{archive_path}/LICENSE
%{_libdir}/*.so.*

%files devel
%{_includedir}/*
%{_libdir}/*.so
%{_libdir}/pkgconfig/*.pc

%files doc
%doc %{archive_path}/html
%doc %{archive_path}/COPYRIGHT
%doc %{archive_path}/CHANGES
%license %{archive_path}/LICENSE


%changelog
* Wed Nov 02 2022 Radovan Sroka <rsroka@redhat.com> - 0.9.24-2
RHEL 8.8.0 ERRATUM
- Please put lmdb in RHEL 8 CRB
- Rebuild
- Resolves: rhbz#1972979

* Thu May 07 2020 Radovan Sroka <rsroka@redhat.com> - 0.9.24-1
- RHEL 8.3.0 ERRATUM
- rebase to 0.9.24
- Resolves: rhbz#1817421

* Tue Jun 18 2019 Radovan Sroka <rsroka@redhat.com> - 0.9.23-5
- fixed resolves from RPMDIFF
- fixed some covscan issues

* Wed Jun 12 2019 Radovan Sroka <rsroka@redhat.com> - 0.9.23-4
- propagate ldflags for makefile
- added explicit Requires for -libs

* Wed May 15 2019 Radovan Sroka <rsroka@redhat.com> - 0.9.23-3
- rebuild

* Mon Apr 29 2019 Radovan Sroka <rsroka@redhat.com> - 0.9.23-2
- Initial Package
- Resolves: rhbz#1692264
