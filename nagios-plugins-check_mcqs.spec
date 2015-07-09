Name:           nagios-plugins-check_mcqs
Version:        1.1
Release:        1%{?dist}
Summary:        A Nagios / Icinga plugin for checking HP MC/ServiceGuard quorum server states

Group:          Applications/System
License:        GPL
URL:            https://github.com/stdevel/check_mcqs
Source0:        nagios-plugins-check_mcqs-%{version}.tar.gz
BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

#BuildRequires:
Requires:       nagios-plugins-tcp nrpe

%description
This package contains a customized Nagios / Icinga plugin for checking HP MC/ServiceGuard quorum server states

Check out the GitHub page for further information: https://github.com/stdevel/check_mcqs

%prep
%setup -q

%build
#change /usr/lib64 to /usr/lib if we're on i686
%ifarch i686
sed -i -e "s/usr\/lib64/usr\/lib/" check_mcqs.cfg
%endif

%install
install -m 0755 -d %{buildroot}%{_libdir}/nagios/plugins/
install -m 0755 check_mcqs.sh %{buildroot}%{_libdir}/nagios/plugins/check_mcqs
%if 0%{?el7}
        install -m 0755 -d %{buildroot}%{_sysconfdir}/nrpe.d/
        install -m 0755 check_mcqs.cfg  %{buildroot}%{_sysconfdir}/nrpe.d/check_mcqs.cfg
%else
        install -m 0755 -d %{buildroot}%{_sysconfdir}/nagios/plugins.d/
        install -m 0755 check_mcqs.cfg  %{buildroot}%{_sysconfdir}/nagios/plugins.d/check_mcqs.cfg
%endif



%clean
rm -rf $RPM_BUILD_ROOT

%files
%if 0%{?el7}
        %config %{_sysconfdir}/nrpe.d/check_mcqs.cfg
%else
        %config %{_sysconfdir}/nagios/plugins.d/check_mcqs.cfg
%endif
%{_libdir}/nagios/plugins/check_mcqs


%changelog
* Thu Jun 09 2015 Christian Stankowic <info@stankowic-development.net> - 1.1.1
- Fixed wrong return code

* Thu Mar 05 2015 Christian Stankowic <info@stankowic-development.net> - 1.0.1
- First release
