mt.exe -manifest "songbase.exe.manifest" -outputresource:"songbase.exe";#1
upx songbase.exe
cd install
copy ..\songbase.exe /y
