@echo off
del /q Release\*

for /f "tokens=* delims=" %%a in ('dir /b') do (
    echo %%a>tempv
    (findstr "\.lua" tempv > nul && (
        copy /y %%a Release\ > nul
    ) || (echo  '') >nul )
    (findstr "\.css \.js \.html \.jpg \.png \.ico" tempv > nul && (
        7z a -tgzip Release\%%a.gz %%a
    ) || (echo  '') >nul )
)

del /q tempv