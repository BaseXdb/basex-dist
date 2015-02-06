# Build BaseX.app from BaseX-latest.jar
#
# Links:
# - http://docs.oracle.com/javase/8/docs/technotes/guides/deploy/package_for_mac.html
# Signing:
# - https://developer.apple.com/library/mac/documentation/security/Conceptual/CodeSigningGuide/Procedures/Procedures.html#//apple_ref/doc/uid/TP40005929-CH4-SW5
# - https://developer.apple.com/library/mac/documentation/IDEs/Conceptual/AppDistributionGuide/MaintainingCertificates/MaintainingCertificates.html#//apple_ref/doc/uid/TP40012582-CH31-SW41
# - https://developer.apple.com/library/ios/documentation/IDEs/Conceptual/AppDistributionGuide/DistributingApplicationsOutside/DistributingApplicationsOutside.html
# Internal Certificate:
# BaseX-Intern/GmbH/Accounts/MacDev/developerID_application_basexgmbh.cer
#
# (c) Copyright 2014 Alexander Holupirek <alex@holupirek.de>
# BSD licensed

.PHONY: files

help:
	@echo 'clean            : remove previous builds'
	@echo 'clean-app        : remove app build only'
	@echo 'get              : download BaseX-latest'
	@echo 'diff             : instructions about the diff file for next patch step'
	@echo 'pkg              : build BaseX.app'
	@echo 'patch            : patch .app to support Retina'
	@echo 'sign             : sign .app to satisfy Gatekeeper'
	@echo 'verify           : check signature'
	@echo 'open             : open BaseX.app'
	@echo 'files            : tar app and create version file for upload'
	@echo 'upload           : upload zipped files to files.basex.org'
	@echo 'www              : open Chrome to check upload'
	@echo 'tree             : show directory hierarchy'
	@echo 'info-java-update : show info about what to do in case of java update'
	@echo 'all              : one run deployment'

all: clean get pkg patch sign files upload tree www

clean:
	@echo '****** [CLEAN] removing previous builds'
	@rm -rf app
	@rm -rf files
	@rm -rf patches
	@rm -rf dist/*.jar*
	@tree .

clean-app:
	@rm -rf app

get:
	@echo '****** [DOWNLOAD] BaseX-latest'
	@curl -o dist/BaseX-latest.jar "http://files.basex.org/releases/BaseX-latest.jar"
	@md5 dist/BaseX-latest.jar >dist/BaseX-latest.jar.md5
	@tree dist
	@cat dist/BaseX-latest.jar.md5

dist/BaseX-latest.jar:
	make get

diff:
	@echo 'Look son, you have to edit the diff manually, because I am to lazy to do this automatically.'
	@echo 'Open in your favourite editor (which should be vim):'
	@echo '   diffs/BaseX.app/Contents/Info.plist'
	@echo '>>CFBundleVersion<< is the current build, which is the git commit piece in following string:'
	@echo '>>CFBundleShortVersionString<< is the ‘marketing’ BaseX version, e.g. 7.9, 8.0'
	@java -cp dist/BaseX-latest.jar org.basex.BaseX -h 2>&1 | head -n 1
	@echo 'Once done proceed with patch'

pkg: dist/BaseX-latest.jar
	@echo '****** [PACKAGING]'
	@mkdir app || exit 0
	@java -jar /Applications/oxygen/tools/ant/lib/ant-launcher.jar bundle-basex

patch:
	@echo '****** [PATCH] create patches from diffs directory'
	@mkdir patches || exit 0
	@diff -u app/BaseX.app/Contents/Info.plist diffs/BaseX.app/Contents/Info.plist >patches/Info.plist.patch || exit 0
	@echo '****** [PATCH] apply patches from diffs directory'
	@patch --verbose ./app/BaseX.app/Contents/Info.plist patches/Info.plist.patch

sign:
	@echo '****** [SIGN] sign with certificate'
	@#codesign --deep -f -v -s "Mac Developer: Alexander Holupirek (ER9NUV223U)" ./app/BaseX.app
	codesign -v -s "Developer ID Application: BaseX GmbH (K88H76ZSQF)" ./app/BaseX.app/Contents/PlugIns/jdk1.8.0_20.jdk
	codesign -v -s "Developer ID Application: BaseX GmbH (K88H76ZSQF)" ./app/BaseX.app
	codesign -d --verbose=4 ./app/BaseX.app # verify that the app is signed

# https://developer.apple.com/library/ios/documentation/IDEs/Conceptual/AppDistributionGuide/DistributingApplicationsOutside/DistributingApplicationsOutside.html
verify:
	sudo spctl --master-enable   # enables assessment
	spctl --status               # shows whether assessment is enabled
	spctl --assess --verbose=4 ./app/BaseX.app # check whether an application can be launched when Gatekeeper is enabled
	sudo spctl --master-disable  # disables assessment
	spctl --status               # shows whether assessment is enabled

open:
	open app/BaseX.app

files:
	@echo '****** [FILES] tar app and create version file for upload'
	@rm -rf files && mkdir files
	(cd app; tar cjf ../files/BaseX-latest.app.tar.bz2  BaseX.app)
	@md5 app/BaseX.app/Contents/Java/BaseX-latest.jar >>files/BaseX-latest.app.info.txt
	@md5 files/BaseX-latest.app.tar.bz2 >>files/BaseX-latest.app.info.txt
	java -cp app/BaseX.app/Contents/Java/BaseX-latest.jar org.basex.BaseX -h 2>&1 | head -n 1 >>files/BaseX-latest.app.info.txt
	ls app/BaseX.app/Contents/PlugIns/ >>files/BaseX-latest.app.info.txt
	tree files
	@cat files/BaseX-latest.app.info.txt

upload:
	scp files/BaseX-latest.app.* basex-web:files/releases

www:
	@echo '****** [BROWSER] open browser'
	open -a /Applications/Google\ Chrome.app http://files.basex.org/releases

tree:
	tree .

info-java-update:
	@echo Listen son, if you have a java update, this information is for you:
	@echo Change Info.plist diff to new version java number.
	@echo diffs
	@echo '└── BaseX.app'
	@echo '    └── Contents'
	@echo '        └── Info.plist'
	@echo '<key>JVMRuntime</key>'
	@echo '<string>jdk1.8.0_20.jdk</string>'
