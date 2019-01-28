@rem Copyright 2017 gRPC authors.
@rem
@rem Licensed under the Apache License, Version 2.0 (the "License");
@rem you may not use this file except in compliance with the License.
@rem You may obtain a copy of the License at
@rem
@rem     http://www.apache.org/licenses/LICENSE-2.0
@rem
@rem Unless required by applicable law or agreed to in writing, software
@rem distributed under the License is distributed on an "AS IS" BASIS,
@rem WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
@rem See the License for the specific language governing permissions and
@rem limitations under the License.

@rem Move python installation from _32bit to _32bits where they are expected by python artifact builder
@rem TODO(jtattermusch): get rid of this hack
rename C:\Python27_32bit Python27_32bits
rename C:\Python34_32bit Python34_32bits
rename C:\Python35_32bit Python35_32bits
rename C:\Python36_32bit Python36_32bits

@rem enter repo root
cd /d %~dp0\..\..\..

call tools/internal_ci/helper_scripts/prepare_build_windows.bat

@rem Move artifacts generated by the previous step in the build chain.
powershell -Command "mv %KOKORO_GFILE_DIR%\github\grpc\artifacts input_artifacts"
dir input_artifacts

@rem TODO: do the signing...

@rem Adjust the location of nuget.exe
set NUGET=nuget.exe
set DOTNET=dotnet
set SIGNTOOL="c:\Program Files (x86)\Windows kits\10\bin\x86\signtool.exe"

%NUGET% update -self
%NUGET% sign Grpc.Core.1.18.0.nupkg -CertificateSubjectName "Google Inc" -Timestamper http://timestamp.comodoca.com/authenticode

mkdir artifacts
xcopy /Y /I *.nupkg artifacts\ 

bash tools/internal_ci/helper_scripts/delete_nonartifacts.sh
