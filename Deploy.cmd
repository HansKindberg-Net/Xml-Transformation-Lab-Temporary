SET MSBuild = "C:\Program Files (x86)\MSBuild\12.0\Bin\MSBuild.exe"

REM %MSBuild% Xml-Transformation-Lab.sln /p:DeployOnBuild=true;PublishProfile=Debug;AllowUntrustedCertificate=true

%MSBuild%

PAUSE