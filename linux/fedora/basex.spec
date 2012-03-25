Name:           basex
Version:        7.2
Release:        1%{?dist}
Summary:        XML database and XPath/XQuery processor

Group:          Applications/Databases
License:        BSD-3-clause
URL:            http://basex.org
Source0:        http://files.basex.org/maven/org/basex/basex/%{version}/%{name}-%{version}.tar.gz
Source1:        https://raw.github.com/BaseXdb/basex-dist/master/linux/debian/man/basex.1
Source2:        https://raw.github.com/BaseXdb/basex-dist/master/linux/debian/man/basexclient.1
Source3:        https://raw.github.com/BaseXdb/basex-dist/master/linux/debian/man/basexserver.1
Source4:        https://raw.github.com/BaseXdb/basex-dist/master/linux/debian/man/basexgui.1
Source5:        https://github.com/BaseXdb/basex-dist/raw/master/images/BaseX_16px.png
Source6:        https://github.com/BaseXdb/basex-dist/raw/master/images/BaseX_32px.png
Source7:        https://github.com/BaseXdb/basex-dist/raw/master/images/BaseX_48px.png
Source8:        https://github.com/BaseXdb/basex-dist/raw/master/images/BaseX_64px.png
Source9:        https://github.com/BaseXdb/basex-dist/raw/master/images/BaseX_128px.png
Source10:       https://github.com/BaseXdb/basex-dist/raw/master/images/BaseX_256px.png
Source11:       https://github.com/BaseXdb/basex-dist/raw/master/images/BaseX_512px.png
Source12:       https://raw.github.com/BaseXdb/basex-dist/master/images/BaseX.svg
Source13:       https://raw.github.com/BaseXdb/basex-dist/master/linux/basex.desktop
Source14:       https://github.com/BaseXdb/basex-dist/raw/master/linux/fedora/%{name}-pom.patch

# patches the pom.xml to remove unneeded sections preventint the package build
Patch0:         %{name}-pom.patch

BuildArch:      noarch

BuildRequires:  jpackage-utils

BuildRequires:  java-devel

BuildRequires:  junit4

BuildRequires:  maven

BuildRequires:    maven-compiler-plugin
BuildRequires:    maven-install-plugin
BuildRequires:    maven-jar-plugin
BuildRequires:    maven-javadoc-plugin
BuildRequires:    maven-release-plugin
BuildRequires:    maven-resources-plugin
BuildRequires:    maven-surefire-plugin
BuildRequires:    maven-source-plugin

Requires:       jpackage-utils
Requires:       java
Requires:       xml-commons-resolver
Requires:       lucene-contrib
Requires:       jline
Requires:       tagsoup

%description
BaseX is a very fast and light-weight, yet powerful XML database and
XPath/XQuery processor, including support for the latest W3C Full Text and
Update Recommendations. It supports large XML instances and offers a highly
interactive front-end (basexgui). Apart from two local standalone modes, BaseX
offers a client/server architecture.

%package javadoc
Summary:        Javadocs for %{name}
Group:          Documentation
Requires:       jpackage-utils

%description javadoc
This package contains the API documentation for %{name}.

%prep
%setup -q
%patch0 -p1

%build
mvn-rpmbuild install javadoc:aggregate -DskipTests

%install
# jars
mkdir -p %{buildroot}%{_javadir}
cp -p target/%{name}-%{version}.jar %{buildroot}%{_javadir}/%{name}.jar

# javadoc
mkdir -p %{buildroot}%{_javadocdir}/%{name}
cp -rp target/site/apidocs %{buildroot}%{_javadocdir}/%{name}

# maven pom
%{__install} -d -m 755 %{buildroot}%{_mavenpomdir}
%{__install} -pm 644 pom.xml %{buildroot}%{_mavenpomdir}/JPP-%{name}.pom

%add_maven_depmap JPP-%{name}.pom %{name}.jar

# desktop file
desktop-file-install --dir=%{buildroot}%{_datadir}/applications %{SOURCE13}

# man pages
%{__install} -d -m 0755 %{buildroot}%{_mandir}/man1/
%{__install} -D -m 644 %{SOURCE1} %{buildroot}%{_mandir}/man1/basex.1
%{__install} -D -m 644 %{SOURCE2} %{buildroot}%{_mandir}/man1/basexclient.1
%{__install} -D -m 644 %{SOURCE3} %{buildroot}%{_mandir}/man1/basexserver.1
%{__install} -D -m 644 %{SOURCE4} %{buildroot}%{_mandir}/man1/basexgui.1

# icons
%{__install} -D -m 644 %{SOURCE5} %{buildroot}%{_datadir}/icons/hicolor/16x16/apps/%{name}.png
%{__install} -D -m 644 %{SOURCE6} %{buildroot}%{_datadir}/icons/hicolor/32x32/apps/%{name}.png
%{__install} -D -m 644 %{SOURCE7} %{buildroot}%{_datadir}/icons/hicolor/48x48/apps/%{name}.png
%{__install} -D -m 644 %{SOURCE8} %{buildroot}%{_datadir}/icons/hicolor/64x64/apps/%{name}.png
%{__install} -D -m 644 %{SOURCE9} %{buildroot}%{_datadir}/icons/hicolor/128x128/apps/%{name}.png
%{__install} -D -m 644 %{SOURCE10} %{buildroot}%{_datadir}/icons/hicolor/256x256/apps/%{name}.png
%{__install} -D -m 644 %{SOURCE11} %{buildroot}%{_datadir}/icons/hicolor/512x512/apps/%{name}.png
%{__install} -D -m 644 %{SOURCE12} %{buildroot}%{_datadir}/icons/hicolor/scalable/apps/%{name}.svg

# start scripts
%jpackage_script org.basex.BaseX       "-Xmx512m" "" %{name}:jline:tagsoup:xml-commons-resolver:lucene-contrib/lucene-analyzers:lucene-contrib/lucene-snowball basex       true
%jpackage_script org.basex.BaseXGUI    "-Xmx512m" "" %{name}:tagsoup:xml-commons-resolver:lucene-contrib/lucene-analyzers:lucene-contrib/lucene-snowball basexgui    true
%jpackage_script org.basex.BaseXServer "-Xmx512m" "" %{name}:jline:tagsoup:xml-commons-resolver:lucene-contrib/lucene-analyzers:lucene-contrib/lucene-snowball basexserver true
%jpackage_script org.basex.BaseXClient ""         "" %{name}:jline basexclient true

%__cat > %{buildroot}%{_bindir}/basexserverstop << EOF
#!/bin/sh
basexserver "\$@" stop
EOF

%files
%defattr(0644,root,root,0755)
%{_mavenpomdir}/JPP-%{name}.pom
%{_mavendepmapfragdir}/%{name}
%{_javadir}/%{name}.jar
%doc

# desktop file
%{_datadir}/applications/%{name}.desktop

# man pages
%{_mandir}/man1/basex.1*
%{_mandir}/man1/basexclient.1*
%{_mandir}/man1/basexserver.1*
%{_mandir}/man1/basexgui.1*

# icons
%{_datadir}/icons/hicolor

# start scripts
%attr(0755,root,root) %{_bindir}/basex
%attr(0755,root,root) %{_bindir}/basexclient
%attr(0755,root,root) %{_bindir}/basexgui
%attr(0755,root,root) %{_bindir}/basexserver
%attr(0755,root,root) %{_bindir}/basexserverstop

%files javadoc
%defattr(0644,root,root,0755)
%{_javadocdir}/%{name}

%post
# update mime-type associations
/usr/bin/update-desktop-database &> /dev/null || :

# touch to force icon cache update
/bin/touch --no-create %{_datadir}/icons/hicolor &>/dev/null || :

%postun
# update mime-type associations
/usr/bin/update-desktop-database &> /dev/null || :

# touch to force icon cache update
if [ $1 -eq 0 ] ; then
    /bin/touch --no-create %{_datadir}/icons/hicolor &>/dev/null
    /usr/bin/gtk-update-icon-cache %{_datadir}/icons/hicolor &>/dev/null || :
fi

%posttrans
/usr/bin/gtk-update-icon-cache %{_datadir}/icons/hicolor &>/dev/null || :

%changelog

* Sun Mar 24 2012 Dimitar Popov <dimitar.popov at  uni-konstanz.de> 7.2-1
- Version 7.2.

* Sun Feb 26 2012 Dimitar Popov <dimitar.popov at  uni-konstanz.de> 7.1.1-1
- Initial release for Fedora.

