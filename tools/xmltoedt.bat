@chcp 65001
del /s /f /q %cd%\tests\fixtures\cf-edt\*.*
for /f %%f in ('dir /ad /b %cd%\tests\fixtures\cf-edt\') do rd /s /q %cd%\tests\fixtures\cf-edt\%%f
ring edt@2020.1.0:x86_64 workspace import --configuration-files "%cd%\tests\fixtures\cf-xml" --project "%cd%\tests\fixtures\cf-edt" --workspace-location "%cd%\build\EDT_workspace"