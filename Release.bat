@echo off
rd /s /q Release
md Release

for /r Web\ %%a in (*) do (
    echo %%a>tempv
    (findstr "\.css \.js \.html \.jpg \.png \.ico" tempv > nul && (
        7z a -tgzip %%a.gz %%a
    ) || (echo  '') >nul )
)
copy /y *.lua Release\
move /y Web\*.gz Release\
copy  /y LICENSE Release\

del /q tempv

tree Release /f >Release\__filelist__