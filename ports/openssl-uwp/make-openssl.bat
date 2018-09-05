call ms\do_vsprojects15.bat
cd vsout\NT-Universal-10.0-Static-Unicode
call  build.bat Release %1 
cd vsout\NT-Universal-10.0-Static-Unicode
call  build.bat Debug %1 

