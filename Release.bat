@echo off
rd /s /q Release
md Release

for /r Web\ %%a in (*) do (
    echo %%a>tempv
    (findstr "\.css \.js \.html \.jpg \.ico" tempv > nul && (
        docs\bin\7zip\7za.exe a -tgzip %%a.gz %%a
    ) || (echo  '') >nul )
)
copy /y *.lua Release\
move /y Web\*.gz Release\
copy /y web\*.png Release\
copy  /y LICENSE Release\

del /q tempv

tree Release /f >Release\__filelist__