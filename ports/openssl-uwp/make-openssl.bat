call ms\do_vsprojects15.bat
pushd vsout
pushd NT-Universal-10.0-Static-Unicode
call build.bat Release %1 
call build.bat Debug %1 
popd
popd

