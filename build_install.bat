if not exist install mkdir install
cd install
copy ..\*.dll
copy ..\Songbase-Manual.pdf
copy ..\*.ocx
del Songbase.exe
copy ..\Songbase.exe Songbase.exe
..\upx Songbase.exe
copy ..\Songbase.exe.manifest
..\mt.exe -manifest "Songbase.exe.manifest" -outputresource:"Songbase.exe";#1
del Songbase.exe.manifest
if not exist html mkdir html
copy ..\songbase.exe /y
copy ..\CHANGES.TXT /y
copy ..\en_GB.xml /y
copy ..\TODO.TXT /y
copy ..\html\*.html html /y
copy ..\..\songbase-classic-viewer\Viewer.exe .. /y
copy ..\..\songbase-classic-viewer\Viewer.ini .. /y
cd ..
