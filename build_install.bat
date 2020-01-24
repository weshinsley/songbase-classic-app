if not exist install mkdir install
cd install
del Songbase.exe
copy ..\Songbase.exe Songbase.exe
..\tools\upx Songbase.exe
copy ..\Songbase.exe.manifest
..\tools\mt.exe -manifest "Songbase.exe.manifest" -outputresource:"Songbase.exe";#1
del Songbase.exe.manifest
copy ..\Songbase.ini /y
copy ..\*.dll /y
copy ..\*.ocx /y
copy ..\Songbase-Manual.pdf /y
copy ..\CHANGES.TXT /y
copy ..\en_GB.xml /y
copy ..\TODO.TXT /y
if not exist html mkdir html
copy ..\html\*.html html /y
copy ..\..\songbase-classic-viewer\Viewer.exe /y
copy ..\..\songbase-classic-viewer\Viewer.ini /y
cd ..
