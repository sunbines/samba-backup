%global with_python3 1

Name: libtalloc
Version: 2.2.0
Release: 1%{?dist}
Summary: The talloc library
License: LGPLv3+
URL: https://talloc.samba.org/
Source: https://www.samba.org/ftp/talloc/talloc-%{version}.tar.gz

# Patches
Patch0001: 0003-wafsamba-Fix-few-SyntaxWarnings-caused-by-regular-ex.patch
Patch0002: talloc-test-leak.patches

BuildRequires: gcc
BuildRequires: libxslt
BuildRequires: docbook-style-xsl
%if 0%{?with_python3}
BuildRequires: python3-devel
%endif
BuildRequires: doxygen

Provides: bundled(libreplace)
Obsoletes: python2-talloc < 2.2.0-1
Obsoletes: python2-talloc-devel < 2.2.0-1

%description
A library that implements a hierarchical allocator with destructors.

%package devel
Summary: Developer tools for the Talloc library
Requires: libtalloc = %{version}-%{release}

%description devel
Header files needed to develop programs that link against the Talloc library.

%if 0%{?with_python3}
%package -n python3-talloc
Summary: Python bindings for the Talloc library
Requires: libtalloc = %{version}-%{release}
%{?python_provide:%python_provide python3-talloc}

%description -n python3-talloc
Python 3 libraries for creating bindings using talloc

%package -n python3-talloc-devel
Summary: Development libraries for python3-talloc
Requires: python3-talloc = %{version}-%{release}
%{?python_provide:%python_provide python3-talloc-devel}

%description -n python3-talloc-devel
Development libraries for python3-talloc
%endif

%prep
%autosetup -n talloc-%{version} -p1

%build
# workaround for https://bugzilla.redhat.com/show_bug.cgi?id=1217376
export python_LDFLAGS=""

%configure --disable-rpath \
           --disable-rpath-install \
           --bundled-libraries=NONE \
           --builtin-libraries=replace \
           --disable-silent-rules

make %{?_smp_mflags} V=1
doxygen doxy.config

%check
make %{?_smp_mflags} check

%install
make install DESTDIR=$RPM_BUILD_ROOT

# Install API docs
cp -a doc/man/* $RPM_BUILD_ROOT/%{_mandir}

%files
%{_libdir}/libtalloc.so.*

%files devel
%{_includedir}/talloc.h
%{_libdir}/libtalloc.so
%{_libdir}/pkgconfig/talloc.pc
%{_mandir}/man3/talloc*.3.gz
%{_mandir}/man3/libtalloc*.3.gz

%if 0%{?with_python3}
%files -n python3-talloc
%{_libdir}/libpytalloc-util.cpython*.so.*
%{python3_sitearch}/talloc.cpython*.so

%files -n python3-talloc-devel
%{_includedir}/pytalloc.h
%{_libdir}/pkgconfig/pytalloc-util.cpython-*.pc
%{_libdir}/libpytalloc-util.cpython*.so
%endif

%post
/sbin/ldconfig

%postun
/sbin/ldconfig

%if 0%{?with_python3}
%post -n python3-talloc
/sbin/ldconfig

%postun -n python3-talloc
/sbin/ldconfig
%endif

%changelog
